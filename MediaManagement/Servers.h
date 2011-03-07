//
//  Servers.h
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServersDelegate.h"

#define SERVERS_REFRESHED @"ServersRefreshed"

@class Server;

@interface Servers : NSObject<NSNetServiceDelegate>
{
  NSNetService *netService;
  NSMutableArray *servers;
  id<ServersDelegate> delegate;
}

@property (readonly) NSArray *servers;
@property (readwrite, retain) id<ServersDelegate> delegate;

- (Server*) serverAtIndexPath: (NSIndexPath*) indexPath;
- (void) refreshServerList;


@end
