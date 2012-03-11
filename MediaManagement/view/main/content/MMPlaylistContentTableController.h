//
//  ContentViewTableViewController.h
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MMEditController.h"

@class MMPlaylist;
@class MMContentGroup;
@class MMPlaylistSubcontentSelector;
@class MMPlaylistContentCell;
@class MMContentView;

@interface MMPlaylistContentTableController : NSObject<UITableViewDelegate, UITableViewDataSource, MMEditControllerDelegate> 
{
  IBOutlet __strong UITableView * table;
  IBOutlet __strong MMPlaylistSubcontentSelector *subcontentSelector;
  IBOutlet __strong UIBarButtonItem *editButton;
  IBOutlet __strong MMContentView *contentView;
  IBOutlet __weak MMPlaylistContentCell *contentCell;
  IBOutlet __weak UIViewController *controller;
  
  __strong MMPlaylistContentCell *sizingContentCell;
  
  __strong NSMutableDictionary *cellSizes;
  
  __strong MMPlaylist *playlist;
  __strong MMContentGroup *selectedContentGroup;
  __strong MMContent *selectedItem;
  
  BOOL loading;
  
}

@property (nonatomic, readwrite, strong) MMPlaylist *playlist;
@property (nonatomic, readonly) MMContentGroup *selectedContentGroup;
@property (nonatomic, readonly) MMContent *selectedItem;

- (void) refresh;
- (IBAction) refreshAction:(id)sender;

@end
