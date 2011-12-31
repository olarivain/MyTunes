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

#import "MMLibraryNavigationTableController.h"

@class MMPlaylist;
@class MMContentView;

@class CategoriesTableViewController;
@class MMPlaylistContentTableController;
@class MMPlaylistSubcontentSelector;
@class MMEncoderTableController;

@interface MMLibraryViewController_iPad : UIViewController<MMEditControllerDelegate, MMLibraryViewController, MMLibraryNavigationTableControllerDelegate>
{
  IBOutlet __strong MMLibraryNavigationTableController *libraryNavigationTableController;
  IBOutlet __strong MMPlaylistContentTableController *playlistContentController;
  IBOutlet __strong  MMEncoderTableController *encoderTableController;
  
  IBOutlet __strong MMContentView *playlistContentView;
  IBOutlet __strong MMContentView *encoderView;
  
  __strong MMPlaylist *selectedPlaylist;
  __strong MMContentGroup *selectedContentGroup;
  __strong MMServer *server;

}

@property (nonatomic, readwrite, strong) MMServer *server;

- (IBAction) editPressed: (id) sender;

@end
