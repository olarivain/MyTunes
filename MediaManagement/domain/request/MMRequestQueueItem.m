//
//  DownloadQueueItem.m
//  ECUtil
//
//  Created by Kra on 6/28/11.
//  Copyright 2011 Kra. All rights reserved.
//

#import "MMRequestQueueItem.h"
#import "MMRequestQueue.h"

#import "JSONKit.h"

@interface MMRequestQueueItem()
@property (nonatomic, readwrite, assign) MMRequestQueue *queue;
@property (nonatomic, readwrite, retain) NSURL *url;
@property (nonatomic, readwrite, retain) NSURLConnection *connection;
@property (nonatomic, readwrite, retain) NSURLResponse *response;
@property (nonatomic, readwrite, retain) NSMutableData *responseData;
@property (nonatomic, readwrite, copy) RequestCallback callback;
@property (nonatomic, readwrite, assign) BOOL success;
@property (nonatomic, readwrite, retain) NSError *error;

- (id) initWithQueue: (MMRequestQueue*) downloadQueue URL: (NSURL*) url andCallback:(RequestCallback) RequestCallback;
- (NSHTTPURLResponse*) httpResponse;
@end

@implementation MMRequestQueueItem

+ (id) downloadQueueItemWithQueue: (MMRequestQueue*) queue URL: (NSURL*) url andCallback:(RequestCallback) RequestCallback {
    return [[[MMRequestQueueItem alloc] initWithQueue: queue URL: url andCallback: RequestCallback] autorelease];
}

- (id) initWithQueue: (MMRequestQueue*) downloadQueue URL: (NSURL*) downloadURL andCallback:(RequestCallback) RequestCallback {
    self = [super init];
    if(self) {
        self.url = downloadURL;
        self.queue = downloadQueue;
        self.callback = RequestCallback;
        self.responseData = [NSMutableData data];
    }
    
    return self;
}

- (void) dealloc {
    self.url = nil;
    self.callback = nil;
    self.queue = nil;
    self.connection = nil;
    self.responseData = nil;
    self.error = nil;
    self.response = nil;
    [super dealloc];
}

@synthesize url;
@synthesize callback;
@synthesize responseData;
@synthesize connection;
@synthesize queue;
@synthesize success;
@synthesize error;
@synthesize response;
@synthesize cancelledInCallbackPhase;
@synthesize requestData;

#pragma mark - Start/Stop methods
- (void) start {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];;
    [request setHTTPBody: requestData];
    if(requestData != nil) {
        [request setHTTPMethod:@"POST"];
    }
    
    self.connection = [NSURLConnection connectionWithRequest: request delegate: self];
    [connection start];
    NSLog(@"Request started");
}

- (void) cancel {
    [connection cancel];
    CFRunLoopStop(CFRunLoopGetCurrent());
}

#pragma mark - JSON converter
- (NSObject*) jsonObject {
    JSONDecoder *decoder = [JSONDecoder decoderWithParseOptions: JKParseOptionLooseUnicode];
    NSObject *object = [decoder objectWithData: responseData];
    return object;
}

- (NSDictionary*) jsonDictionary {
    NSObject *object = [self jsonObject];
    if([object isKindOfClass: [NSDictionary class]]){
        return (NSDictionary *) object;
    }
    
    return nil;
}

- (NSArray*) jsonArray {
    NSObject *object = [self jsonObject];
    if([object isKindOfClass: [NSArray class]]){
        return (NSArray *) object;
    }
    
    return nil;
}

#pragma mark - HTTP convenience
- (NSInteger) status {
    NSHTTPURLResponse *httpResponse = [self httpResponse];
    if(httpResponse == nil) {
        return -1;
    }
       
    return [httpResponse statusCode];
}

- (NSDictionary*) headers {
    NSHTTPURLResponse *httpResponse = [self httpResponse];
    if(httpResponse == nil) {
        return nil;
    }
    
    return [httpResponse allHeaderFields];
}

- (NSHTTPURLResponse*) httpResponse {
    if(response == nil) {
        return nil;
    }
    
    if(![response isKindOfClass: [NSHTTPURLResponse class]]){
        return nil;
    }
    return (NSHTTPURLResponse*) response;
}

#pragma mark - NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse {
    NSLog(@"Got Response.");
    self.response = aResponse;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)newData  {
    [responseData appendData: newData];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Response finished");
    success = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    [queue requestFinished: self];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)failure {
    success = NO;
    self.error = failure;
    [queue requestFinished: self];
    CFRunLoopStop(CFRunLoopGetCurrent());
}

@end
