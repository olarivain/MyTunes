//
//  MMLibrary+Server.m
//  MediaManagement
//
//  Created by Kra on 5/14/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <KraCommons/KCBlocks.h>
#import <KraCommons/KCHTTPClient.h>
#import <MediaManagement/MMPlaylist.h>

#import "MMRemoteLibrary.h"
#import "MMServer.h"

#import "MMContentAssembler+Client.h"

@interface MMRemoteLibrary()
@property (nonatomic, readwrite, weak) MMServer *server;
@property (nonatomic, readwrite, strong) NSMutableArray *systemPlaylists;
@property (nonatomic, readwrite, strong) NSMutableArray *userPlaylists;
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
		self.server = parent;
		self.systemPlaylists = [NSMutableArray arrayWithCapacity: 6] ;
		self.userPlaylists = [NSMutableArray arrayWithCapacity: 10];
	}
	return self;
}

#pragma mark - playlist management
- (void) clear
{
	[super clear];
	[_systemPlaylists removeAllObjects];
	[_userPlaylists removeAllObjects];
}

- (void) addPlaylist: (MMPlaylist*) mediaLibrary
{
	[super addPlaylist:mediaLibrary];
	if([self.systemPlaylists containsObject: mediaLibrary] || [self.userPlaylists containsObject: mediaLibrary])
	{
		return;
	}
	mediaLibrary.library = self;
	
	NSMutableArray *targetList = [mediaLibrary isSystem] ? _systemPlaylists : _userPlaylists;
	[targetList addObject: mediaLibrary];
}

- (BOOL) hasUserPlaylist
{
	return [self.userPlaylists count] > 0;
}

@end
