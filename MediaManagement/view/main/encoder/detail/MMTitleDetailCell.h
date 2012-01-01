//
//  MMTitleListDetailCell.h
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 Edmunds. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMTitle;
@class MMAudioTrackListView;

@class MMAudioTrackTableController;
@class MMTitleDetailCellSize;

@interface MMTitleDetailCell : UITableViewCell
{
  IBOutlet __strong UILabel *nameLabel;
  IBOutlet __strong UILabel *durationLabel;
  
  IBOutlet __strong UITableView *audioTracksTable;
  IBOutlet __strong MMAudioTrackTableController *audioTableController;
}

- (void) updateWithTitle: (MMTitle *) title andSize: (MMTitleDetailCellSize *) size;

- (void) updateSizeWithWidth: (CGFloat) width;
- (MMTitleDetailCellSize *) sizeForTitle: (MMTitle *) title;

@end
