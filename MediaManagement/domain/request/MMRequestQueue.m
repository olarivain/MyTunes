//
//  DownloadQueue.m
//  ECUtil
//
//  Created by Kra on 6/28/11.
//  Copyright 2011 Kra. All rights reserved.
//

#import "MMRequestQueue.h"
#import "MMRequestQueueItem.h"

static MMRequestQueue *sharedInstance;

@interface MMRequestQueue()
+ (MMRequestQueue*) shardInstance;
@property (nonatomic, readwrite, retain) NSMutableArray *pending;
@property (nonatomic, readwrite, retain) NSMutableArray *active;
@property (nonatomic, readwrite, retain) NSMutableArray *processing;
@property (nonatomic, readwrite, retain) NSOperationQueue *downloadOperationQueue;
@property (nonatomic, readwrite, retain) NSOperationQueue *callbackOperationQueue;

- (MMRequestQueueItem*) addURL: (NSURL*) url callback: (DownloadCallback) callback;
- (MMRequestQueueItem*) addURL: (NSURL*) url withData: (NSData*) data andCallback: (DownloadCallback) callback;
- (MMRequestQueueItem*) addURL: (NSURL*) url forBackground: background callback: (DownloadCallback) callback;

- (void) cancelDownloadItem: (MMRequestQueueItem*) url;
- (void) cancelFromPending: (MMRequestQueueItem*) item;
- (void) cancelFromActive: (MMRequestQueueItem*) item;
- (void) cancelFromCallback: (MMRequestQueueItem*) item;

- (BOOL) canProcessNextQueueItem;
- (void) processNextQueueItem;

- (void) downloadfinishedBlock: (MMRequestQueueItem *) item;

@end

@implementation MMRequestQueue

- (id) init {
    self = [super init];
    if(self){
        self.pending = [NSMutableArray arrayWithCapacity:20];
        self.active = [NSMutableArray arrayWithCapacity: 20];
        self.processing = [NSMutableArray arrayWithCapacity: 20];
        maxConcurrentDownloads = 5;
        currentConcurrentDownloads = 0;
        
        downloadOperationQueue = [[NSOperationQueue alloc] init];
        [downloadOperationQueue setMaxConcurrentOperationCount: maxConcurrentDownloads];
        
        callbackOperationQueue = [[NSOperationQueue alloc] init];
        [callbackOperationQueue setMaxConcurrentOperationCount: 2*maxConcurrentDownloads];
    }
    return self;
}

- (void) dealloc {
    self.pending = nil;
    self.active = nil;
    self.processing = nil;
    self.downloadOperationQueue = nil;
    self.callbackOperationQueue = nil;
    [super dealloc];
}

// lazy singleton constructor
+ (MMRequestQueue*) shardInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MMRequestQueue alloc] init];
    });
    return sharedInstance;
}

@synthesize pending;
@synthesize active;
@synthesize processing;
@synthesize downloadOperationQueue;
@synthesize callbackOperationQueue;

#pragma mark - Static methods wrapping singleton calls
+ (MMRequestQueueItem*) scheduleURL:(NSURL *)url withCallback:(DownloadCallback)callback {
    return [[MMRequestQueue shardInstance] addURL:url callback:callback];
}

+ (MMRequestQueueItem*) scheduleURL: (NSURL*) url withData: (NSData *) data andCallback: (DownloadCallback) callback {
    return [[MMRequestQueue shardInstance] addURL:url withData: data andCallback:callback];
}

+ (MMRequestQueueItem*) scheduleURL:(NSURL *)url forBackground:(id)background withCallback:(DownloadCallback)callback {
    return  [[MMRequestQueue shardInstance] addURL:url forBackground:background callback:callback];
}

+ (void) cancelItem: (MMRequestQueueItem*) item {
    [[MMRequestQueue shardInstance] cancelDownloadItem: item];
}

#pragma mark - Add URL method
- (MMRequestQueueItem*) addURL: (NSURL*) url callback: (DownloadCallback) callback {
    return [self addURL: url withData: nil andCallback: callback];
}

- (MMRequestQueueItem*) addURL: (NSURL*) url withData: (NSData*) data andCallback: (DownloadCallback) callback {
    MMRequestQueueItem *item = nil;
    @synchronized(self){
        // create and item to pending queue
        item = [MMRequestQueueItem downloadQueueItemWithQueue: self URL: url andCallback: callback];
        [pending addObject: item];
    }
    
    // process if we're done
    [self processNextQueueItem];
    return  item;

}

- (MMRequestQueueItem*) addURL: (NSURL*) url forBackground: background callback: (DownloadCallback) callback {
    // TODO implement properly
    return [self addURL:url callback:callback];
}

#pragma mark - Cancellation
- (void) cancelDownloadItem:(MMRequestQueueItem *)item {
    // cancel from pending, then from active if not found
    [self cancelFromPending: item];
    [self cancelFromActive: item];
    [self cancelFromCallback: item];
}

- (void) cancelFromPending: (MMRequestQueueItem*) item {
    BOOL found = NO;
    // iterate through pending list, if found remove it from pending queue
    for(MMRequestQueueItem *candidate in pending) {
        if(candidate == item) {
            found = YES;
            break;
        }
    }
    if(found) {
        [pending removeObject: item];
    }
}

- (void) cancelFromActive: (MMRequestQueueItem*) item {
    BOOL found = NO;
    // iterate through active downloads, if found cancel and remove from active list
    for(MMRequestQueueItem *candidate in active) {
        if(candidate == item) {
            found = YES;
            break;
        }
    }
    
    if(found) {
        [item cancel];
        [active removeObject: item];
    }
}

- (void) cancelFromCallback: (MMRequestQueueItem*) item {
    // iterate through callback item, if found, set cancel flag to YES.
    for(MMRequestQueueItem *candidate in active) {
        if(candidate == item) {
            candidate.cancelledInCallbackPhase = YES;
            break;
        }
    }
}

#pragma mark - Queue processing
- (BOOL) canProcessNextQueueItem {
    // we can process if we not all concurrent downloads are used
    return currentConcurrentDownloads < maxConcurrentDownloads;
}
- (void) processNextQueueItem {
    MMRequestQueueItem *item = nil;
    @synchronized(self) {
        // if we can't process next item, bail out
        if(![self canProcessNextQueueItem] || [pending count] == 0) {
            return;
        }
        
        // move next download to processing queue and increment concurrent download
        item = [pending objectAtIndex: 0];
        [processing addObject: item];
        [pending removeObject: item];
        
        currentConcurrentDownloads++;
    }
    
    // just a safeguard, shouldn't happen
    if(item == nil) {
        return;
    }
    
    // async download API will callback on the thread that initiated the download.
    // We will certainly call this from the UI thread and it's not acceptable to have 
    // download code happening on the UI thread - hence the NSOperation to move this to
    // a background thread.
    [downloadOperationQueue addOperationWithBlock:^(void) {
        [item start];
        // CFRunLoopRun prevents the operation from terminating. This would result
        // in the download never processing, since the thread would be gone.
        // NOTE: the download item MUST call CFRunLoopStop(), otherwise this operation 
        // will NEVER end.
         CFRunLoopRun();
    }];

}

// download is finished, send clean up + callback code to the callback operation queue.
- (void) downloadFinished:(MMRequestQueueItem *)item {
    void(^finishedBlock)(void) = ^() {
        [self downloadfinishedBlock: item];  
    };
    
    [callbackOperationQueue addOperationWithBlock: finishedBlock];
}

- (void) downloadfinishedBlock: (MMRequestQueueItem *) item {
    // move to processing queue and decrement current active DL count
    [processing addObject: item];
    [active removeObject: item];
    currentConcurrentDownloads--;
    
    // start processing next item
    [self processNextQueueItem];
    
    // callback if we're supposed to
    DownloadCallback callback = item.callback;
    if(callback) {
        callback(item);
    }
    
    // remove from processing queue. this object is going to die now.
    [processing removeObject: item];
}

@end
