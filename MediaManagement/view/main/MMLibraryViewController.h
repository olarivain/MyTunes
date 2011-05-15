//
//  MMLibraryController.h
//  MediaManagement
//
//  Created by Kra on 5/15/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMServer;
@class MMPlaylist;

@interface MMLibraryViewController : UIViewController 
{
  MMPlaylist *selectedPlaylist;
  
  MMServer *server;
}

@property (nonatomic, readwrite, retain) MMServer *server;

- (IBAction) editPressed: (id) sender;

@end
