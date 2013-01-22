//
//  MYTPlaylistContentDataSource.h
//  MyTunes
//
//  Created by Olivier Larivain on 1/21/13.
//
//

#import <Foundation/Foundation.h>

@class MMPlaylist;
@class MMContent;

@protocol MYTPlaylistContentDataSourceDelegate <NSObject>

- (void) didSelectContent: (MMContent *) content;

@end

@protocol MYTPlaylistContentDataSource <NSObject, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak, readwrite) IBOutlet id<MYTPlaylistContentDataSourceDelegate> delegate;
@property (nonatomic, strong, readwrite) MMPlaylist *playlist;
@property (nonatomic, strong, readonly) NSArray *content;

- (void) reload: (BOOL) unwatched;

@end
