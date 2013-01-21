//
//  MYTMoviePlaylistDataSource.h
//  MyTunes
//
//  Created by Olivier Larivain on 1/21/13.
//
//

#import <Foundation/Foundation.h>

@class MMPlaylist;

@interface MYTMoviePlaylistDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong, readwrite) MMPlaylist *playlist;

@end
