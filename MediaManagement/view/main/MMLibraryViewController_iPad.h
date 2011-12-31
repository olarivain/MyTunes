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
#import "MMLibraryViewController.h"

#import "MMPlaylistTableController.h"

@class MMPlaylist;
@class MMContentView;

@class CategoriesTableViewController;
@class MMPlaylistContentTableController;
@class MMPlaylistSubcontentSelector;


@interface MMLibraryViewController_iPad : UIViewController<MMEditControllerDelegate, MMLibraryViewController, MMPlaylistTableControllerDelegate>
{
  IBOutlet __strong MMPlaylistTableController *playlistTableController;
  IBOutlet __strong UIBarButtonItem *editButton;
  IBOutlet __strong MMPlaylistContentTableController *contentController;
  
  IBOutlet __strong MMContentView *contentView;
  
  __strong MMPlaylist *selectedPlaylist;
  __strong MMContentGroup *selectedContentGroup;
  __strong MMServer *server;

}

@property (nonatomic, readwrite, strong) MMServer *server;

- (IBAction) editPressed: (id) sender;

@end
