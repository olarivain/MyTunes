//
//  MMPlaylistContentCell.h
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMContent;
@class MMPlaylistContentCellSize;

@interface MMPlaylistContentCell : UITableViewCell
{
  IBOutlet __strong UILabel *name;
  IBOutlet __strong UILabel *number;
  IBOutlet __strong UILabel *duration;
}

- (void) updateWithContent: (MMContent *) content withCellSize: (MMPlaylistContentCellSize *) size;

- (void) updateSizeWithWidth: (CGFloat) width;
- (MMPlaylistContentCellSize *) sizeForContent: (MMContent *) content;

@end
