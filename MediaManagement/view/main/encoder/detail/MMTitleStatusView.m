//
//  MMTitleStatus.m
//  MediaManagement
//
//  Created by Olivier Larivain on 3/10/12.
//  Copyright (c) 2012 kra. All rights reserved.
//

#import <MediaManagement/MMTitle.h>

#import "MMTitleStatusView.h"

@implementation MMTitleStatusView


- (void) updateWithTitle:(MMTitle *)title
{ 
  self.hidden = !title.selected;
  
  // set up default values
  NSString *etaString = @"";
  NSString *statusString = @"Pending";
  
  // and update if status is not the default value
  if(title.completed)
  {
    statusString = @"Completed";
  }
  
  if(title.encoding)
  {
    statusString = @"Encoding";
    etaString = title.formattedProgress;
  }
  
  // now reinject that in the views
  status.text = statusString;
  progress.text = etaString;
}

@end
