//
//  ContentViewTableViewController.h
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMPlaylist;
@class MMContentGroup;
@class MMPlaylistSubcontentSelector;

@interface MMPlaylistContentTableController : NSObject<UITableViewDelegate, UITableViewDataSource> 
{
  IBOutlet __strong UITableView * table;
  IBOutlet __strong MMPlaylistSubcontentSelector *subcontentSelector;
  
  __strong MMPlaylist *playlist;
  __strong MMContentGroup *selectedContentGroup;
  __strong MMContent *selectedItem;
  
}

@property (nonatomic, readwrite, strong) MMPlaylist *playlist;
@property (nonatomic, readonly) MMContentGroup *selectedContentGroup;
@property (nonatomic, readonly) MMContent *selectedItem;

- (void) refresh;

@end
