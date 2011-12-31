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

@protocol MMPlaylistTableControllerDelegate <NSObject>

- (void) didSelectPlaylist: (MMPlaylist *) playlist;

@end

@interface MMPlaylistTableController : NSObject<UITableViewDelegate, UITableViewDataSource>
{
  IBOutlet __strong UITableView *table;
  IBOutlet __weak id<MMPlaylistTableControllerDelegate> delegate;
  __strong MMRemoteLibrary *library;
}

@property (nonatomic, readwrite, strong) MMRemoteLibrary *library;

- (void) selectFirstPlaylist;

@end
