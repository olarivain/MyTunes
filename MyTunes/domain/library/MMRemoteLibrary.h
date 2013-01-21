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

typedef void(^MMRemoteLibraryCallback)(void);

/*
 A remote library represents the full library held by the remote iTunes instance.
 Its "headers" (i.e. the playlists descriptions) can be loaded.
 */
@interface MMRemoteLibrary : MMLibrary

@property (nonatomic, readonly, weak) MMServer *server;
@property (nonatomic, readonly, strong) NSArray *systemPlaylists;
@property (nonatomic, readonly, strong) NSArray *userPlaylists;

+ (id) libraryWithServer: (MMServer*) server;
- (id) initWithServer: (MMServer*) server;

- (BOOL) hasUserPlaylist;

@end
