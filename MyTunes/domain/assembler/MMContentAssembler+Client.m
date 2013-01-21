//
//  MMContentAssembler+Client.m
//  MediaManagement
//
//  Created by Kra on 5/15/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <MediaManagement/MMLibrary.h>
#import <MediaManagement/MMPlaylist.h>
#import <MediaManagement/MMMoviesPlaylist.h>
#import <MediaManagement/MMTVShowPlaylist.h>
#import <MediaManagement/MMContent.h>

#import "MMContentAssembler+Client.h"



@implementation MMContentAssembler (MMContentAssembler_Client)

- (MMPlaylist*) mediaLibraryForKind: (MMContentKind) kind andSize: (NSUInteger) count
{
    MMPlaylist *library = nil;
    switch (kind) {
        case MOVIE:
            library = [MMMoviesPlaylist playlistWithKind: MOVIE andSize: count];
            break;
        case TV_SHOW:
            library = [MMTVShowPlaylist playlistWithKind: TV_SHOW andSize: count];
            break;
        default:
            break;
    }
    return library;
}

- (MMPlaylist*) createPlaylist:(NSDictionary *)dictionary
{
    NSNumber *kindNumber = [dictionary nullSafeForKey:@"kind"];
    if(kindNumber == nil)
    {
        return nil;
    }
    
    MMContentKind kind = [kindNumber intValue];
    NSArray *contents = [dictionary nullSafeForKey: @"content"];
    
    MMPlaylist *playlist = [self mediaLibraryForKind: kind andSize: [contents count]];
    playlist.uniqueId = [dictionary nullSafeForKey:@"uniqueId"];
    playlist.name = [dictionary nullSafeForKey:@"name"];
    
    for(NSDictionary *contentDictionary in contents)
    {
        MMContent *content = [self createContent: contentDictionary];
        [playlist addContent: content];
    }
    
    return playlist;
}

- (MMLibrary *) createLibrary: (NSArray*) dto
{
	MMLibrary *library = [[MMLibrary alloc] init];
	for(NSDictionary *playlistDto in dto)
	{
		MMPlaylist *playlist = [self createPlaylist: playlistDto];
		[library addPlaylist: playlist];
	}
    return library;
}

- (void) updatePlaylist: (MMPlaylist*) playlist withDto: (NSDictionary*) dto
{
	[playlist clear];
	NSArray *contentDtos = [dto objectForKey:@"content"];
	for(NSDictionary *contentDto in contentDtos)
	{
		MMContent *content = [self createContent: contentDto];
		[playlist addContent: content];
	}
	[playlist sortContent];
}

@end
