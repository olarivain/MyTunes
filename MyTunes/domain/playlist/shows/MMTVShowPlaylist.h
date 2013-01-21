//
//  MMTVShowPlaylist.h
//  MediaManagementCommon
//
//  Created by Kra on 5/31/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMPlaylistProtected.h"

@interface MMTVShowPlaylist : MMPlaylist
{
}

@property (nonatomic, readonly) NSArray *sortedSeasons;
@property (nonatomic, readonly) NSArray *sortedUnwatchedSeasons;

@end
