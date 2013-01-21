//
//  MMEncoder.h
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/30/11.
//  Copyright (c) 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMPendingList;
@class MMTitleList;
@class MMServer;

typedef void(^MMRemoteEncoderCallback)(void);
typedef void(^MMRemoteEncoderErrorCallback)(NSError *);

@interface MMRemoteEncoder : NSObject
{
}

+ (MMRemoteEncoder *) encoderWithServer: (MMServer *) server;

@property (nonatomic, readonly) NSArray *availableResources;
@property (nonatomic, readonly) MMPendingList *pendingList;

- (void) loadAvailableResources: (MMRemoteEncoderCallback) callback;
- (void) scanResource: (MMTitleList *) titleList andCallback: (MMRemoteEncoderCallback) callback;
- (void) scheduleTitleList: (MMTitleList *) title withCallback: (MMRemoteEncoderCallback) callback;

- (void) deleteTitleList: (MMTitleList *) title withCallback: (MMRemoteEncoderErrorCallback) callback;

@end
