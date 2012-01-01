//
//  MainViewController_iPad.h
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMLibraryViewController.h"

#import "MMLibraryViewController.h"

#import "MMLibraryNavigationTableController.h"

@class MMPlaylist;

@class MMContentView;
@class MMPlaylistContentTableController;
@class MMPlaylistSubcontentSelector;
@class MMTitleListSummaryTableController;

@interface MMLibraryViewController_iPad : UIViewController<MMLibraryViewController, MMLibraryNavigationTableControllerDelegate>
{
  IBOutlet __strong MMLibraryNavigationTableController *libraryNavigationTableController;
  IBOutlet __strong MMPlaylistContentTableController *playlistContentController;
  IBOutlet __strong  MMTitleListSummaryTableController *encoderTableController;
  
  IBOutlet __strong MMContentView *playlistContentView;
  IBOutlet __strong MMContentView *encoderView;
  
  __strong MMPlaylist *selectedPlaylist;
  __strong MMServer *server;

}

@property (nonatomic, readwrite, strong) MMServer *server;

@end
