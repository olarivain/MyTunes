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
  IBOutlet UITableView *table;
}


@property (nonatomic, readwrite, assign) UITableView *table;
@property (nonatomic, readwrite, retain) MMContentGroup *selectedContentGroup;

- (void) refresh;

@end
