//
//  MMRemotePlaylist.m
//  MediaManagement
//
//  Created by Kra on 5/14/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMRemotePlaylist.h"
#import "MMQuery.h"
#import "MMRemoteLibrary.h"
#import "MMContentAssembler+Client.h"

@interface MMPlaylist()
- (MMQuery*) readQuery;
- (MMQuery*) writeQuery;
- (MMQuery*) writeQueryForContent: (MMContent *) content;
- (void) reload: (NSObject*) dto;
@end

@implementation MMPlaylist(MMPlaylist_Remote)

#pragma mark - Query generators
- (MMQuery*) readQuery
{
  NSString *path = [NSString stringWithFormat:@"/library/%@", uniqueId];
  MMQuery *query = [MMQuery queryWithName: @"Read" andPath: path];
  
  // TODO make this a little bit more fail proof
  MMRemoteLibrary *remoteLibrary = (MMRemoteLibrary *) library;
  query.server = remoteLibrary.server;
  return query;
}

- (MMQuery*) writeQuery
{
  return [self writeQueryForContent: nil];
}

- (MMQuery*) writeQueryForContent: (MMContent *) content
{
  NSString *path = [NSString stringWithFormat:@"/library/%@/%@", uniqueId, content.contentId];
  MMQuery *query = [MMQuery queryWithName: @"Write" andPath: path];
  
  // TODO make this a little bit more fail proof
  MMRemoteLibrary *remoteLibrary = (MMRemoteLibrary *) library;
  query.server = remoteLibrary.server;
  return query;
}

#pragma mark - Network calls
- (void) loadWithBlock: (void(^)(void)) callback
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

  MMQuery *query = [self readQuery];
  [query requestWithCallback: reload];
}

- (void) updateContent: (MMContent*) content withBlock: (void(^)(void)) callback
{
  NSDictionary *dictionary = [[MMContentAssembler sharedInstance] writeContent: content];
  MMQueryCallback updated = ^(NSObject *dto){
    // dispatch on callback on main thread and exit
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, callback);
  };
  
  MMQuery *query = [self writeQueryForContent: content];
  [query updateRequestWithParams: dictionary andCallback: updated];

}

#pragma mark - Network callbacks
#pragma mark Read
- (void) reload: (NSObject*) dto
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

@end
