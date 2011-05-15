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
@protocol MMServersDelegate <NSObject>

@optional
- (void) didRefresh: (MMServers*) sender;
- (void) willRefresh: (MMServers*) sender;

- (void) server: (MMServer*) server receivedContent: (NSArray*) content;
- (void) server: (MMServer*) server loadedContent: (NSArray*) content;

@end
