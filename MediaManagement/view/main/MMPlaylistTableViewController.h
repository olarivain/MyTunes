//
//  ContentViewTableViewController.h
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMPlaylist;
@class MMPlaylistContentType;

@interface MMPlaylistTableViewController : NSObject<UITableViewDelegate, UITableViewDataSource> {
  MMPlaylist *playlist;
  MMPlaylistContentType *selectedContentType;
  IBOutlet UITableView *table;
}


@property (nonatomic, readwrite, assign) UITableView *table;
@property (nonatomic, readwrite, retain) MMPlaylist *playlist;
@property (nonatomic, readwrite, retain) MMPlaylistContentType *selectedContentType;

- (void) refresh;

@end
