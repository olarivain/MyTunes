//
//  MMEncoderTableController.h
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/30/11.
//  Copyright (c) 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMRemoteEncoder;
@class MMTitleListSummaryCell;

@interface MMTitleListSummaryTableController : NSObject<UITableViewDataSource, UITableViewDelegate>
{
  IBOutlet __strong UITableView *table;
  IBOutlet __weak MMTitleListSummaryCell *resourceCell;
  IBOutlet __weak UIViewController *controller;
  
  __strong MMRemoteEncoder *encoder;
}

@property (nonatomic, readwrite, strong) MMRemoteEncoder *encoder;

- (void) refresh;

@end
