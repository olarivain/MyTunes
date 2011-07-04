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

@interface MMRequestDelegate : NSObject {
    MMServer *server;
}

+ (id) delegateWithServer: (MMServer *) baseServer;
- (id) initWithServer: (MMServer *) base;

- (MMRequestQueueItem*) requestWithPath: (NSString *) path andCallback: (DownloadCallback) callback;
- (MMRequestQueueItem*) requestWithPath: (NSString *) path params: (NSDictionary *) params  andCallback: (DownloadCallback) callback;
- (MMRequestQueueItem*) requestWithPath: (NSString *) path data: (NSData *) data andCallback: (DownloadCallback) callback;
@end
