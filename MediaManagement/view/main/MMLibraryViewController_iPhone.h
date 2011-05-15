//
//  MainViewController_iPhone.h
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMServer;
@class MMEditController;

@interface MMLibraryViewController_iPhone : UIViewController 
{
  IBOutlet MMEditController *editController;
  MMServer *server;
}

@property (nonatomic, readwrite, retain) MMServer *server;

- (IBAction) editPressed: (id) sender;


@end
