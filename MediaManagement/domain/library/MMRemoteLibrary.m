//
//  MMLibrary+Server.m
//  MediaManagement
//
//  Created by Kra on 5/14/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <MediaManagement/MMPlaylist.h>
#import <MediaManagement/MMPlaylist.h>

#import "MMContentAssembler+Client.h"
#import "MMRemoteLibrary.h"
#import "MMQuery.h"


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

- (void) clear
{
  [super clear];
  [systemPlaylists removeAllObjects];
  [userPlaylists removeAllObjects];
}

- (void) addPlaylist: (MMPlaylist*) mediaLibrary
{
  [super addPlaylist:mediaLibrary];
  if([systemPlaylists containsObject: mediaLibrary] || [userPlaylists containsObject: mediaLibrary])
  {
    return;
  }
  
  NSMutableArray *targetList = [mediaLibrary isSystem] ? systemPlaylists : userPlaylists;
  [targetList addObject: mediaLibrary];
}

- (void) reload: (NSObject*) dto
{
  // sanity check
  if(![dto isKindOfClass: [NSArray class]])
  {
    NSLog(@"FATAL: unexpected content fetched from %@.", [query path]);
  }
  
  NSArray *playlistDtos = (NSArray*) dto;
  
  // now assemble playlists and add them to self.
  MMContentAssembler *assembler = [MMContentAssembler sharedInstance];
  [assembler updateLibrary: self withDto: playlistDtos];  
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
