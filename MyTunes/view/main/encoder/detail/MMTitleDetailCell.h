//
//  MMTitleListDetailCell.h
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMTitle;
@class MMAudioTrackListView;

@class MMTitleTrackTableController;
@class MMSubtitleTrackTableController;
@class MMTitleDetailCellSize;

@interface MMTitleDetailCell : UITableViewCell
{
  IBOutlet __weak UILabel *nameLabel;
  IBOutlet __weak UILabel *durationLabel;
  IBOutlet __weak UILabel *statusLabel;
  IBOutlet __weak UILabel *progressLabel;
  
  IBOutlet __weak UITableView *titleTracksTable;
  IBOutlet __strong MMTitleTrackTableController *titleTableController;
}

- (void) updateWithTitle: (MMTitle *) title andSize: (MMTitleDetailCellSize *) size;

- (void) updateSizeWithWidth: (CGFloat) width;
- (MMTitleDetailCellSize *) sizeForTitle: (MMTitle *) title;

@end
