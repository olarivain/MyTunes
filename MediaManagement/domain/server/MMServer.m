//
//  iServer.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//


#import <MediaManagement/MMContent.h>

#import "MMServer.h"
#import "MMRemoteLibrary.h"
#import "MMQuery.h"

@interface MMServer()
@end

@implementation MMServer
+ (MMServer *) serverWithNetService: (NSNetService*) netService
{
  return [[MMServer alloc] initWithNetService: netService];
}

- (id) initWithNetService: (NSNetService*) service
{
  self = [super init];
  if(self)
  {
    netService = service;
    library = [MMRemoteLibrary libraryWithServer: self];
  }
  return self;
}


@synthesize name;
@synthesize port;
@synthesize host;
@synthesize library;
@synthesize netService;

#pragma mark - Bonjour resolution
- (void) didResolve
{
  port = [netService port];
  
  host = [netService hostName];
  name = [[host componentsSeparatedByString:@".local"] objectAtIndex:0];

}

#pragma mark - Synthetic getter
- (NSString*) serverURL
{
  return [NSString stringWithFormat:@"http://%@:%i", host, port];
}

#pragma mark - Playlist convenience
- (BOOL) hasSystemPlaylist
{
  return [library.systemPlaylists count] > 0;
}

@end
