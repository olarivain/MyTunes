//
//  MMLibrary+Server.m
//  MediaManagement
//
//  Created by Kra on 5/14/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMRemoteLibrary.h"
#import "MMQuery.h"
#import "MMPlaylist.h"

@implementation MMRemoteLibrary

+ (id) libraryWithServer: (MMServer*) server
{
  return  [[[MMLibrary alloc] initWithServer: server] autorelease];
}

- (id) initWithServer: (MMServer*) parent 
{
  self = [super init];
  if(self)
  {
    server = parent;
    query = [[MMQuery alloc] initWithName: @"all" andPath:@"/library"];
    query.server = server;
    systemPlaylists = [[NSMutableArray alloc] initWithCapacity: 6];
    userPlaylists = [[NSMutableArray alloc] initWithCapacity: 10];
  }
  return self;
}

- (void) dealloc
{
  [query release];
  [systemPlaylists release];
  [userPlaylists release];
  [super dealloc];
}

@synthesize server;
@synthesize query;
@synthesize systemPlaylists;
@synthesize userPlaylists;

- (void) addMedialibrary: (MMPlaylist*) mediaLibrary
{
  [super addMedialibrary:mediaLibrary];
  if([systemPlaylists containsObject: mediaLibrary] || [userPlaylists containsObject: mediaLibrary])
  {
    return;
  }
  
  NSMutableArray *targetList = [mediaLibrary isSystem] ? systemPlaylists : userPlaylists;
  [targetList addObject: mediaLibrary];
}

- (void) reload: (NSObject*) dto
{
  // TODO put reload code here.
}

- (void) loadHeadersWithBlock: (void(^)(void)) callback
{
  void (^reload)(NSObject *dto) = ^(NSObject *dto){
    [self reload: dto];
    if(callback != nil)
    {
      // dispatch on callback on main thread and exit
      dispatch_queue_t mainQueue = dispatch_get_main_queue();
      dispatch_async(mainQueue, callback);
    }
  };
  
  [query asyncFetchWithBlock: reload];
}

@end
