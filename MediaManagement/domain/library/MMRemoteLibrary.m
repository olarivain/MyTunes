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

@interface MMRemoteLibrary()
@property (nonatomic, readwrite, retain) MMQuery *query;
@property (nonatomic, readwrite, assign) MMServer *server;
@property (nonatomic, readwrite, retain) NSArray *systemPlaylists;
@property (nonatomic, readwrite, retain) NSArray *userPlaylists;
@end

@implementation MMRemoteLibrary

+ (id) libraryWithServer: (MMServer*) server
{
  return  [[[MMRemoteLibrary alloc] initWithServer: server] autorelease];
}

- (id) initWithServer: (MMServer*) parent 
{
  self = [super init];
  if(self)
  {
    self.server = parent;
    self.query = [[MMQuery alloc] initWithName: @"all" andPath:@"/library"];
    query.server = server;
    self.systemPlaylists = [NSMutableArray arrayWithCapacity: 6] ;
    self.userPlaylists = [NSMutableArray arrayWithCapacity: 10];
  }
  return self;
}

- (void) dealloc
{
  self.query = nil;
  self.server = nil;
  self.systemPlaylists = nil;
  self.userPlaylists = nil;

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
  mediaLibrary.library = self;
  
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

- (void) loadHeadersWithBlock: (MMRemoteLibraryCallback) callback
{
  MMQueryCallback reload = ^(NSObject *dto){
    [self reload: dto];
    if(callback != nil)
    {
      // dispatch on callback on main thread and exit
      dispatch_queue_t mainQueue = dispatch_get_main_queue();
      dispatch_async(mainQueue, callback);
    }
  };
  
  [query requestWithCallback: reload];
}

@end
