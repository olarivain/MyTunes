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
@class MMContentView;

@interface MMTitleListSummaryTableController : NSObject<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
  IBOutlet __strong UITableView *table;
  IBOutlet __weak MMTitleListSummaryCell *resourceCell;
  IBOutlet __weak UIViewController *controller;
  IBOutlet __strong MMContentView *contentView;
  IBOutlet __strong UIView *loadingView;
  
  __strong MMTitleList *titlePendingDelete;
  __strong MMRemoteEncoder *encoder;

}

@property (nonatomic, readwrite, strong) MMRemoteEncoder *encoder;

- (void) refresh;
- (IBAction) refreshAction:(id)sender;

@end
