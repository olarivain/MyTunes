//
//  MMLibrary+Server.m
//  MediaManagement
//
//  Created by Kra on 5/14/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <KraCommons/KCBlocks.h>
#import <MediaManagement/MMPlaylist.h>

#import "MMRemoteLibrary.h"
#import "MMServer.h"

#import "MMContentAssembler+Client.h"

@interface MMRemoteLibrary()
- (void) didLoad: (NSObject*) dto;
@end

@implementation MMRemoteLibrary

+ (id) libraryWithServer: (MMServer*) server
{
  return  [[MMRemoteLibrary alloc] initWithServer: server];
}

- (id) initWithServer: (MMServer*) parent 
{
  self = [super init];
  if(self)
  {
    server = parent;
    systemPlaylists = [NSMutableArray arrayWithCapacity: 6] ;
    userPlaylists = [NSMutableArray arrayWithCapacity: 10];
  }
  return self;
}

@synthesize server;
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

#pragma mark - Network calls 
#pragma mark loading library content
- (void) loadHeadersWithBlock: (MMRemoteLibraryCallback) callback
{
  MMServerCallback reload = ^(id dto){
    [self didLoad: dto];
    DispatchMainThread(callback);
  };
  
  [server requestWithPath:@"/library" andCallback: reload];
}

- (void) didLoad: (id) dto
{
  // sanity check
  if(![dto isKindOfClass: [NSArray class]])
  {
    NSLog(@"FATAL: unexpected content fetched from load library request");
  }
  
  NSArray *playlistDtos = (NSArray*) dto;
  
  // now assemble playlists and add them to self.
  MMContentAssembler *assembler = [MMContentAssembler sharedInstance];
  [assembler updateLibrary: self withDto: playlistDtos];  
}

@end
