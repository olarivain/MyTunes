//
//  MainViewController_iPad.h
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMServer;
@class CategoriesTableViewController;
@class ContentTableViewController;

@interface MainViewController_iPad : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
  IBOutlet UIBarButtonItem *editButton;
  
  IBOutlet CategoriesTableViewController *categoriesController;
  IBOutlet ContentTableViewController *contentController;
  
  MMServer *server;
}

@property (nonatomic, readwrite, retain) MMServer *server;

- (IBAction) editPressed: (id) sender;

@end
