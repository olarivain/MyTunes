//
//  MMContentAssembler+Client.m
//  MediaManagement
//
//  Created by Kra on 5/15/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <MediaManagement/MMLibrary.h>
#import <MediaManagement/MMPlaylist.h>
#import <MediaManagement/MMContent.h>
#import "MMContentAssembler+Client.h"



@implementation MMContentAssembler (MMContentAssembler_Client)

- (void) updateLibrary: (MMLibrary*) library withDto: (NSArray*) dto
{
  [library clearPlaylists];
  
  for(NSDictionary *playlistDto in dto)
  {
    MMPlaylist *playlist = [self createPlaylist: playlistDto];
    [library addPlaylist: playlist];
  }
}

- (void) updatePlaylist: (MMPlaylist*) playlist withDto: (NSDictionary*) dto
{
  [playlist clearPlaylist];
  NSArray *contentDtos = [dto objectForKey:@"content"];
  for(NSDictionary *contentDto in contentDtos)
  {
    MMContent *content = [self createContent: contentDto];
    [playlist addContent: content];
  }
}

@end
