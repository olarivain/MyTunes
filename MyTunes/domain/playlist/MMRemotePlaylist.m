//
//  MMRemotePlaylist.m
//  MediaManagement
//
//  Created by Kra on 5/14/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <KraCommons/KCBlocks.h>
#import "MMRemotePlaylist.h"

#import "MMRemoteLibrary.h"
#import "MMContentAssembler+Client.h"

#import "MMServer.h"

@interface MMPlaylist(MMPlaylist_Remote_Private)
- (void) didLoad: (NSObject*) dto;

@property (nonatomic, readonly) MMServer *server;
@end

@implementation MMPlaylist(MMPlaylist_Remote)

#pragma mark - Synthetic Getter
- (MMServer *) server
{
  return ((MMRemoteLibrary *) library).server;
}
#pragma mark - Reading playlist content
- (void) loadWithBlock: (MMPlaylistCallback) callback
{
  MMServerCallback reload = ^(id dto){
    [self didLoad: dto];
    DispatchMainThread(callback);
  };

  NSString *readPath = [NSString stringWithFormat:@"/library/%@", uniqueId];
  [self.server requestWithPath: readPath andCallback: reload];
}

- (void) didLoad: (NSObject*) dto
{
  if(![dto isKindOfClass: [NSDictionary class]])
  {
    NSLog(@"FATAL: got unexpected response while reading playlist with ID %@.", uniqueId);
    return;
  }
  
  NSDictionary *dictionary = (NSDictionary*) dto;
  MMContentAssembler *assembler = [MMContentAssembler sharedInstance];
  [assembler updatePlaylist: self withDto: dictionary];
}


#pragma mark - Updating a playlist item
- (void) updateContent: (MMContent*) content withBlock: (MMPlaylistCallback) callback
{
  MMServerCallback updated = ^(id dto){
      DispatchMainThread(callback);
  };
 
  NSString *path = [NSString stringWithFormat:@"/library/%@/%@", uniqueId, content.contentId];
  NSDictionary *dictionary = [[MMContentAssembler sharedInstance] writeContent: content]; 
  
  [self.server updateRequestWithPath: path params: dictionary andCallback: updated];
}

@end
