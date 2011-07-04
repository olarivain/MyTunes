//
//  DownloadQueue.h
//  ECUtil
//
//  Created by Kra on 6/28/11.
//  Copyright 2011 Kra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMRequestQueueItem;

// callback typedef
typedef void(^DownloadCallback)(MMRequestQueueItem*);

/*
 DownloadQueue is a scheduler for downloads.
 Once scheduled, a URL will go through three phases:
 - Pending. The download is waiting for the next available slot. DownloadQueue limits the number of concurrent downloads to 5.
 - Active. The download is now active and getting (or waiting for) data from the network.
 - Callback. The network call is complete, the queue has now called the callback method for that object. Not that a download can 
 be submitted without a callback if the caller is not interested in the server response.
 
 A DownloadQueue can:
 - schedule a download for execution as soon as possible (First In, First Out).
 - schedule a given DownloadItem for low priority, background download (not implemented yet).
 - schedule a high priority download that will bypass FIFO rules (not implemented yet). Those downloads will always be scheduled for immediate execution, even if the no download slots are available.
 - cancel a download, may it be pending or active. Due to the technical architecture of NSOperationQueue, downloads in the 
    callback phase can NOT be cancelled. Callers should NEVER directly cancel a DownloadItem, but rather send the DownloadQueue that
 created it the cancel: message. Ideally, when we have time, we should move internal methods to a different header file.
 
 On scheduling, the DownloadQueue will build a DownloadQueueItem encapsulating the URL to be called, the callback method. It also
 provides convenience methods to access to HTTP status codes, in case the caller wants to handle a 304 Not changed for example, or wants
 access to HTTP headers.
 This object is returned by the scheduling methods in case the caller would need them, for cancelling a download for examples.
 It is safe for the caller to retain these, however callers do NOT have ownership of the objects (i.e. it is not their responsibility
 to make sure it has been dealloc'd).
 */
@interface MMRequestQueue : NSObject {
    NSMutableArray *pending;
    NSMutableArray *active;
    NSMutableArray *processing;
    int maxConcurrentDownloads;
    int currentConcurrentDownloads;
    
    NSOperationQueue *downloadOperationQueue;
    NSOperationQueue *callbackOperationQueue;
}

// schedules given URL for download, associating it with given download
+ (MMRequestQueueItem*) scheduleURL: (NSURL*) url withCallback: (DownloadCallback) callback;

+ (MMRequestQueueItem*) scheduleURL: (NSURL*) url withData: (NSData *) data andCallback: (DownloadCallback) callback;

// schedules given URL for background download, associating it with given download. Currently a passthrough on
// +scheduleURL:withCallback:
+ (MMRequestQueueItem*) scheduleURL: (NSURL*) url forBackground: background withCallback: (DownloadCallback) callback;

// cancels given download queue item. Downloads can only be cancelled in pending or active phase, not in callback phase.
+ (void) cancelItem: (MMRequestQueueItem*) url;

// internal method, DO NOT CALL.
- (void) downloadFinished: (MMRequestQueueItem*) item;
@end
