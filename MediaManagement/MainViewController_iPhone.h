//
//  MainViewController_iPhone.h
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Server;
@class EditController;

@interface MainViewController_iPhone : UIViewController 
{
  IBOutlet EditController *editController;
  Server *server;
}

@property (nonatomic, readwrite, retain) Server *server;

- (IBAction) editPressed: (id) sender;


@end
