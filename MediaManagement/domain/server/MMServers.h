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
  __strong NSNetServiceBrowser *netServiceBrowser;
  __strong NSMutableArray *servers;
  __strong NSMutableArray *netServices;
  __weak id<MMServersDelegate> delegate;
  BOOL didStartSearch;
}

@property (nonatomic, readonly) NSArray *servers;
@property (nonatomic, readwrite, weak) id<MMServersDelegate> delegate;

- (void) startSearch;

@end
