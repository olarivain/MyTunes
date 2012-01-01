//
//  MMTitleListDetailCell.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 Edmunds. All rights reserved.
//

#import <MediaManagement/MMTitle.h>

#import "MMTitleDetailCell.h"
#import "MMAudioTrackTableController.h"

@implementation MMTitleDetailCell

- (void) updateWithTitle: (MMTitle *) title
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
    
  audioTableController.audioTracks = title.audioTracks;
  [audioTableController refresh];
}

@end
