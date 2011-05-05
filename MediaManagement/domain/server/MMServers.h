//
//  Servers.h
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServersDelegate.h"

#define SERVERS_REFRESHED @"ServersRefreshed"

@class MMServer;

@interface MMServers : NSObject<NSNetServiceBrowserDelegate, NSNetServiceDelegate>
{
  NSNetServiceBrowser *netServiceBrowser;
  NSMutableArray *servers;
  NSMutableArray *pendingServers;
  id<MMServersDelegate> delegate;
}

@property (readonly) NSArray *servers;
@property (readwrite, retain) id<MMServersDelegate> delegate;

- (void) refreshServerList;


@end