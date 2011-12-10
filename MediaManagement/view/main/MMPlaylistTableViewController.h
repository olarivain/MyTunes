//
//  ContentViewTableViewController.h
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMPlaylist;
@class MMContentGroup;

@interface MMPlaylistTableViewController : NSObject<UITableViewDelegate, UITableViewDataSource> {
  MMContentGroup *selectedContentGroup;
  MMContent *selectedItem;
  IBOutlet __strong UITableView * table;
}

@property (nonatomic, readwrite, strong) MMContentGroup *selectedContentGroup;
@property (nonatomic, readonly, strong) MMContent *selectedItem;

- (void) refresh;

@end
