//
//  MMTitleListViewController.h
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MMTitleTrackTableController.h"

@class MMRemoteEncoder;
@class MMLoadingView;
@class MMTitleList;
@class MMTitleDetailCell;

@interface MMTitleListDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MMTitleTrackTableDelegate>
{
  IBOutlet __strong MMLoadingView *loadingView;
  IBOutlet __strong UITableView *table;
  IBOutlet __strong UILabel *titleLabel;
  IBOutlet __weak MMTitleDetailCell *titleCell;
  __strong MMTitleDetailCell *sizingTitleCell;
  
  __strong NSMutableDictionary *cellSizes;
  
  __strong MMRemoteEncoder *encoder;
  __strong NSString *resourceId;
  __strong MMTitleList *titleList;
}

@property (nonatomic, readwrite, strong) MMRemoteEncoder *encoder;
@property (nonatomic, readwrite, strong) MMTitleList *titleList;

- (IBAction) schedule:(id)sender;
- (IBAction) cancel:(id)sender;

@end
