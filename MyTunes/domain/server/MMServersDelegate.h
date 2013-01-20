//
//  ServersDelegate.h
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MMServers;
@class MMServer;

/**
 Protocol wrapping Bonjour delegate, letting controllers now that servers have been added/removed from the servers list.
 */
@protocol MMServersDelegate <NSObject>

- (void) didRefresh: (MMServers*) sender;
- (void) willRefresh: (MMServers*) sender;

@end
