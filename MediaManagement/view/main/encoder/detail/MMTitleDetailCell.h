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
@class MMTitleStatusView;

@interface MMTitleDetailCell : UITableViewCell
{
  IBOutlet __strong UILabel *nameLabel;
  IBOutlet __strong UILabel *durationLabel;
  IBOutlet __strong MMTitleStatusView *statusView;
  
  IBOutlet __weak UITableView *titleTracksTable;
  IBOutlet __strong MMTitleTrackTableController *titleTableController;
}

- (void) updateWithTitle: (MMTitle *) title andSize: (MMTitleDetailCellSize *) size;

- (void) updateSizeWithWidth: (CGFloat) width;
- (MMTitleDetailCellSize *) sizeForTitle: (MMTitle *) title;

@end
