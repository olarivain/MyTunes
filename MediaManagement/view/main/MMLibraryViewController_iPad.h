//
//  MainViewController_iPad.h
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMLibraryViewController.h"

@class CategoriesTableViewController;
@class MMPlaylistTableViewController;
@class MMContentView;

@interface MMLibraryViewController_iPad : MMLibraryViewController<UITableViewDelegate, UITableViewDataSource>
{
  IBOutlet UIBarButtonItem *editButton;
  IBOutlet MMPlaylistTableViewController *contentController;
  
  IBOutlet MMContentView *contentView;
  

}

- (IBAction) editPressed: (id) sender;

@end
