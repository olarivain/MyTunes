//
//  ECDownloadService.h
//  ECUtil
//
//  Created by Kra on 6/29/11.
//  Copyright 2011 Kra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMRequestQueue.h"

@class MMRequestQueueItem;
@class MMServer;

/*
 High level wrapper on the RequestQueue, encapsulates a Server to make it more convenient to request a given server with having
 to carry around the actual base url.
 Not sure this class is that useful actually, should most likely remove it in favor of direct calls to RequestQueue API.
 */
@interface MMRequestDelegate : NSObject {
    MMServer *__weak server;
}

+ (id) delegateWithServer: (MMServer *) baseServer;
- (id) initWithServer: (MMServer *) base;

// simple GET, no params
- (MMRequestQueueItem*) requestWithPath: (NSString *) path andCallback: (RequestCallback) callback;

// simple GET, params are considered HTTP URL params
- (MMRequestQueueItem*) requestWithPath: (NSString *) path params: (NSDictionary *) params andCallback: (RequestCallback) callback;
// exposes method, params are considered HTTP URL params if method is GET, will be serialized to JSON as body otherwise
- (MMRequestQueueItem*) requestWithPath: (NSString *) path params: (NSDictionary *) params method: (NSString *) method andCallback: (RequestCallback) callback;
@end
