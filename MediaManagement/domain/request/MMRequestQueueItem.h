//
//  RequestQueueItem.h
//  ECUtil
//
//  Created by Kra on 6/28/11.
//  Copyright 2011 Kra. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MMRequestQueue.h"
/*
 RequestQueueItem is a high level abstraction for a scheduled requests.
 It also is the placeholder for request specific data: url, callback and response.
 RequestQueueItem provides high level methods to get access to the response:
 - Raw response NSData,
 - Parsed JSON,
 - HTTP status code,
 - HTTP headers
 
 In case the connection failed, the callback will still be called. Caller can check the "success" property to know
 wether a download went through.
 In case success is NO, the "error" property will hold the NSError sent to the NSURLConnection delegate.
 If the download is successfully cancelled, the callback will NOT be called.
 */
@interface MMRequestQueueItem : NSObject {
    MMRequestQueue *queue;
    RequestCallback callback;
    NSURL *url;
    NSData *requestData;
    
    NSURLConnection *connection;
    NSURLResponse *response;

    NSMutableData *responseData;
    
    BOOL success;
    NSError *error;
    
    BOOL cancelledInCallbackPhase;
}

// URL this object will/has requested
@property (nonatomic, readonly, retain) NSURL *url;

// request body, if any
@property (nonatomic, readonly, retain) NSData *requestData;

// callback block that will be called when request is done. Can be nil.
@property (nonatomic, readonly, copy) RequestCallback callback;

@property (nonatomic, readonly, assign) BOOL success;
@property (nonatomic, readonly, retain) NSError *error;

// Raw server response.
@property (nonatomic, readonly, retain) NSData *responseData;

@property (nonatomic, readwrite, assign) BOOL cancelledInCallbackPhase;

+ (id) requestQueueItemWithQueue: (MMRequestQueue*) queue URL: (NSURL*) url andCallback:(RequestCallback) RequestCallback;
- (void) start;
- (void) cancel;

// NSData parsed as JSON.
- (NSObject*) jsonObject;
- (NSDictionary*) jsonDictionary;
- (NSArray*) jsonArray;
// HTTP status code
- (NSInteger) status;
// HTTP headers
- (NSDictionary *) headers;

@end
