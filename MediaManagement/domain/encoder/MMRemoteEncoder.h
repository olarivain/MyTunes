//
//  MMEncoder.h
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/30/11.
//  Copyright (c) 2011 Edmunds. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMPendingList;
@class MMTitleList;
@class MMServer;

typedef void(^MMRemoteEncoderCallback)(void);

@interface MMRemoteEncoder : NSObject
{
  __weak MMServer *server;
  __strong NSArray *availableResources;
  __strong MMPendingList *pendingList;
}

+ (MMRemoteEncoder *) encoderWithServer: (MMServer *) server;

@property (nonatomic, readonly) NSArray *availableResources;
@property (nonatomic, readonly) MMPendingList *pendingList;

- (void) loadAvailableResources: (MMRemoteEncoderCallback) callback;
- (void) scanResource: (MMTitleList *) titleList andCallback: (MMRemoteEncoderCallback) callback;

@end
