//
//  MainViewController_iPad.h
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMServer;
@class EditController;
@class CategoriesTableViewController;
@class ContentTableViewController;
@class BaseMainViewController;

@interface MainViewController_iPad : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
  IBOutlet UIBarButtonItem *editButton;
  IBOutlet EditController *editController;
  
  IBOutlet CategoriesTableViewController *categoriesController;
  IBOutlet ContentTableViewController *contentController;
  
  BaseMainViewController *baseController;
  MMServer *server;
}

@property (nonatomic, readwrite, retain) MMServer *server;

- (IBAction) editPressed: (id) sender;

@end
