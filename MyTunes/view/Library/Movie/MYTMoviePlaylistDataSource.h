//
//  MYTMoviePlaylistDataSource.h
//  MyTunes
//
//  Created by Olivier Larivain on 1/21/13.
//
//

#import <Foundation/Foundation.h>

#import "MYTPlaylistContentDataSource.h"

@interface MYTMoviePlaylistDataSource : NSObject<MYTPlaylistContentDataSource>

@property (nonatomic, strong, readwrite) MMPlaylist *playlist;

@end
