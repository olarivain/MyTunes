//
//  MainViewController_iPad.h
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMServer;
@class MMPlaylist;
@class CategoriesTableViewController;
@class MMPlaylistTableViewController;
@class MMContentView;

@interface MMLibraryViewController_iPad : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
  IBOutlet UIBarButtonItem *editButton;
  IBOutlet MMPlaylistTableViewController *contentController;
  
  IBOutlet MMContentView *contentView;
  
  MMPlaylist *selectedPlaylist;
  
  MMServer *server;
}

@property (nonatomic, readwrite, retain) MMServer *server;

- (IBAction) editPressed: (id) sender;

@end
