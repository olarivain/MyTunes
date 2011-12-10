//
//  MainViewController_iPad.h
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMLibraryViewController.h"

#import "MMEditController.h"

@class CategoriesTableViewController;
@class MMPlaylistTableViewController;
@class MMContentView;
@class MMPlaylistSubcontentSelector;
@class MMPlaylist;

@interface MMLibraryViewController_iPad : MMLibraryViewController<UITableViewDelegate, UITableViewDataSource, MMEditControllerDelegate>
{
  IBOutlet UITableView *playlistTable;
  
  IBOutlet UIBarButtonItem *editButton;
  IBOutlet MMPlaylistTableViewController *contentController;
  
  IBOutlet MMContentView *contentView;
  IBOutlet MMPlaylistSubcontentSelector *subcontentSelector;

}

@end
