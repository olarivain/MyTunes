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

- (void) didDeselectContent: (MMContent *) content
            withContentList: (NSArray *) contentList;
- (void) didSelectContent: (MMContent *) content
          withContentList: (NSArray *) contentList;

@end

@protocol MYTPlaylistContentDataSource <NSObject, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak, readwrite) IBOutlet id<MYTPlaylistContentDataSourceDelegate> delegate;
@property (nonatomic, strong, readwrite) MMPlaylist *playlist;
@property (nonatomic, strong, readonly) NSArray *contentList;

- (void) reload: (BOOL) unwatched;
- (void) deselectCurrentCell;

@end
