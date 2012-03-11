//
//  MMTitleListDetailCell.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 kra. All rights reserved.
//

#import <MediaManagement/MMTitle.h>

#import "MMTitleDetailCell.h"

#import "MMTitleDetailCellSize.h"
#import "MMTitleTrackTableController.h"
#import "MMTitleStatusView.h"

@implementation MMTitleDetailCell

- (void) updateWithTitle: (MMTitle *) title andSize: (MMTitleDetailCellSize *) size
{
  nameLabel.text = [NSString stringWithFormat:@"Title %i", title.index];

  int hours = title.duration / 3600;
  int remainingHours = ((int) title.duration) % 3600;
  int min = remainingHours / 60;
  int sec = remainingHours % 60;
  
  // skip hour if not available
  if(hours > 0)
  {
    durationLabel.text = [NSString stringWithFormat: @"%02i:%02i:%02i", hours, min, sec];    
  }
  else
  {
    durationLabel.text = [NSString stringWithFormat: @"%02i:%02i", min, sec];    
  }
  
  [statusView updateWithTitle: title];
  
  // size title tracks table to a perfect match
  CGRect titleTracksFrame = titleTracksTable.frame;
  titleTracksFrame.size.height = size.titleTracksHeight;
  titleTracksFrame.origin.y =   title.selected ? CGRectGetMaxY(statusView.frame) : CGRectGetMaxY(durationLabel.frame);
  titleTracksTable.frame = titleTracksFrame;
  
  // and update the tracks table controller
  titleTableController.title = title;
  [titleTableController refresh];
}

- (void) updateSizeWithWidth: (CGFloat) width
{
  CGRect theFrame = self.frame;
  theFrame.size.width = width;
  self.frame = theFrame;
}

- (MMTitleDetailCellSize *) sizeForTitle: (MMTitle *) title
{
  MMTitleDetailCellSize *size = [MMTitleDetailCellSize titleDetailCellSize];
  
  size.titleTracksHeight = [titleTableController totalHeightForAudioTracks: title.audioTracks andSubtitleTracks: title.subtitleTracks];
  CGFloat startPoint = title.selected ? CGRectGetMaxY(statusView.frame) : CGRectGetMaxY(durationLabel.frame);
  size.totalHeight = 2 * CGRectGetMinY(nameLabel.frame) + startPoint + size.titleTracksHeight;
  return size;
}

@end
