//
//  Servers.h
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMServersDelegate.h"

#define SERVERS_REFRESHED @"ServersRefreshed"

@class MMServer;

/*
 MMServers is the root aggregate for all servers reachable on the network, may they be announced through
 Bonjour or manually added by the user (this feature is not implemented yet, though).
 MMServers provides Bonjour abstraction and offers in return the list of reachable servers.
 */
@interface MMServers : NSObject<NSNetServiceBrowserDelegate, NSNetServiceDelegate>
{
  NSNetServiceBrowser *netServiceBrowser;
  NSMutableArray *servers;
  NSMutableArray *pendingServers;
  id<MMServersDelegate> delegate;
  BOOL didStartSearch;
}

@property (nonatomic, readonly, retain) NSArray *servers;
@property (nonatomic, readwrite, assign) id<MMServersDelegate> delegate;

- (void) startSearch;

@end
