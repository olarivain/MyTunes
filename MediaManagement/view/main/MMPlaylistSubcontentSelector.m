//
//  MMPlaylistSubcontentSelector.m
//  MediaManagement
//
//  Created by Kra on 5/15/11.
//  Copyright 2011 kra. All rights reserved.
//
#import <MediaManagement/MMContentGroup.h>

#import "MMPlaylistSubcontentSelector.h"

@implementation MMPlaylistSubcontentSelector

- (void)dealloc
{
  self.segmentedControl = nil;
  self.contentGroups = nil;
  [super dealloc];
}

@synthesize contentGroups;
@synthesize segmentedControl;

- (void) setContentGroups:(NSArray *)contentTypes
{
  if(contentGroups == contentTypes)
  {
    return;
  }
  
  [contentTypes retain];
  [contentGroups release];
  contentGroups = contentTypes;
  
  [segmentedControl removeAllSegments];
  segmentedControl.hidden = NO;
  
  for(MMContentGroup *contentType in contentGroups)
  {
    NSInteger count = [segmentedControl numberOfSegments];
    [segmentedControl insertSegmentWithTitle: contentType.name atIndex: count animated: NO];
  }
  segmentedControl.selectedSegmentIndex = 0;
}

- (MMContentGroup*) selectedContentGroup
{
  if([contentGroups count] <= segmentedControl.selectedSegmentIndex)
  {
    return nil;
  }
  
  return [contentGroups objectAtIndex: segmentedControl.selectedSegmentIndex];
}

@end