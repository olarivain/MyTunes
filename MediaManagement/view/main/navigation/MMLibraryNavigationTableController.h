//
//  MMPlaylistTableController.h
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/30/11.
//  Copyright (c) 2011 Edmunds. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMRemoteLibrary;
@class MMPlaylist;
@class MMLibraryNavigationCell;

@protocol MMLibraryNavigationTableControllerDelegate <NSObject>

- (void) didSelectPlaylist: (MMPlaylist *) playlist;
- (void) didSelectEncoderResources;
- (void) didSelectPendingEncodings;
@end

@interface MMLibraryNavigationTableController : NSObject<UITableViewDelegate, UITableViewDataSource>
{
  IBOutlet __strong UITableView *table;
  IBOutlet __weak MMLibraryNavigationCell *navigationCell;
  IBOutlet __weak id<MMLibraryNavigationTableControllerDelegate> delegate;
  __strong MMRemoteLibrary *library;
}

@property (nonatomic, readwrite, strong) MMRemoteLibrary *library;

- (void) selectPlaylist: (MMPlaylist *) playlist;

@end
