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

@implementation MMTitleDetailCell

- (void) updateWithTitle: (MMTitle *) title andSize: (MMTitleDetailCellSize *) size
{
#warning take the label size off main thread
  nameLabel.text = [NSString stringWithFormat:@"Title %i", title.index];
  [nameLabel sizeToFit];
  
  CGFloat nameMaxX = CGRectGetMaxX(nameLabel.frame);
  
  // set status label
  statusLabel.text = title.formattedStatus;
  [statusLabel sizeToFit];
  // and reposition right next to name label
  CGRect statusFrame = statusLabel.frame;
  statusFrame.origin.x = nameMaxX + 10; 
  statusLabel.frame = statusFrame;
  
  // set progress and reposition appropriately
  progressLabel.text = title.formattedProgress;
  [progressLabel sizeToFit];
  
  CGRect progressFrame = progressLabel.frame;
  progressFrame.origin.x = CGRectGetMaxX(statusFrame) + 10;
  progressLabel.frame = progressFrame;
  
  // compute duration
#warning move this bullshit to MMTitle
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
  
  // size title tracks table to a perfect match
  CGRect titleTracksFrame = titleTracksTable.frame;
  titleTracksFrame.size.height = size.titleTracksHeight;
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
  size.totalHeight = 2 * CGRectGetMinY(nameLabel.frame) + CGRectGetMaxY(durationLabel.frame) + size.titleTracksHeight;
  return size;
}

@end
