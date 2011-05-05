//
//  ContentViewTableViewController.h
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMQuery;

@interface ContentTableViewController : NSObject<UITableViewDelegate, UITableViewDataSource> {
  MMQuery *query;
  UITableView *table;
}


@property (nonatomic, readwrite, assign) UITableView *tableView;
@property (nonatomic, readwrite, retain) MMQuery *query;

- (void) refresh;

@end
