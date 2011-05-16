//
//  MMPlaylistSubcontentSelector.m
//  MediaManagement
//
//  Created by Kra on 5/15/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMPlaylistSubcontentSelector.h"

#import "MMPlaylistContentType.h"

@implementation MMPlaylistSubcontentSelector

- (void)dealloc
{
  self.segmentedControl = nil;
  self.playlistContentTypes = nil;
  [super dealloc];
}

@synthesize playlistContentTypes;
@synthesize segmentedControl;

- (void) setPlaylistContentTypes:(NSArray *)contentTypes
{
  if(playlistContentTypes == contentTypes)
  {
    return;
  }
  
  [contentTypes retain];
  [playlistContentTypes release];
  playlistContentTypes = contentTypes;
  
  [segmentedControl removeAllSegments];
  for(MMPlaylistContentType *contentType in playlistContentTypes)
  {
    NSInteger count = [segmentedControl numberOfSegments];
    [segmentedControl insertSegmentWithTitle: contentType.name atIndex: count animated: YES];
  }
  segmentedControl.selectedSegmentIndex = 0;
}

- (MMPlaylistContentType*) selectedContentType
{
  if([playlistContentTypes count] <= segmentedControl.selectedSegmentIndex)
  {
    return nil;
  }
  
  return [playlistContentTypes objectAtIndex: segmentedControl.selectedSegmentIndex];
}

@end
