//
//  MMLibrary+Server.h
//  MediaManagement
//
//  Created by Kra on 5/14/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaManagement/MMLibrary.h>

@class MMQuery;
@class MMServer;

@interface MMRemoteLibrary : MMLibrary 
{
  MMQuery *query;
  MMServer *server;
  
  NSMutableArray *systemPlaylists;
  NSMutableArray *userPlaylists;
}

@property (nonatomic, readonly) MMQuery *query;
@property (nonatomic, readonly) MMServer *server;
@property (nonatomic, readonly) NSArray *systemPlaylists;
@property (nonatomic, readonly) NSArray *userPlaylists;

+ (id) libraryWithServer: (MMServer*) server;
- (id) initWithServer: (MMServer*) server;

- (void) loadHeadersWithBlock: (void(^)(void)) callback;

@end
