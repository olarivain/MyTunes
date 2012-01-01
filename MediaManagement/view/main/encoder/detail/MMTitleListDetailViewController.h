//
//  MMTitleListViewController.h
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 Edmunds. All rights reserved.
//

@class MMRemoteEncoder;
@class MMLoadingView;
@class MMTitleList;
@class MMTitleDetailCell;

@interface MMTitleListDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
  IBOutlet __strong MMLoadingView *loadingView;
  IBOutlet __strong UITableView *table;
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
