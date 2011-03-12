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

@class Server;

@interface Servers : NSObject<NSNetServiceBrowserDelegate, NSNetServiceDelegate>
{
  NSNetServiceBrowser *netServiceBrowser;
  NSMutableArray *servers;
  NSMutableArray *pendingServers;
  id<ServersDelegate> delegate;
}

@property (readonly) NSArray *servers;
@property (readwrite, retain) id<ServersDelegate> delegate;

- (void) refreshServerList;


@end
