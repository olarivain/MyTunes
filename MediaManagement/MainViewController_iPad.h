//
//  MainViewController_iPad.h
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Server;
@class EditController;
@class CategoriesTableViewController;
@class ContentTableViewController;

@interface MainViewController_iPad : UIViewController 
{
  IBOutlet UIBarButtonItem *editButton;
  IBOutlet EditController *editController;
  
  IBOutlet CategoriesTableViewController *categoriesController;
  IBOutlet ContentTableViewController *contentController;
  
  Server *server;
}

@property (nonatomic, readwrite, retain) Server *server;

- (IBAction) editPressed: (id) sender;

@end
