//
//  MYTPlaylistContentDataSource.h
//  MyTunes
//
//  Created by Olivier Larivain on 1/21/13.
//
//

#import <Foundation/Foundation.h>

@class MMPlaylist;

@protocol MYTPlaylistContentDataSource <NSObject, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong, readwrite) MMPlaylist *playlist;

- (void) reload: (BOOL) unwatched;

@end
