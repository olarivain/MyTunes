//
//  MMPlaylistSubcontentSelector.h
//  MediaManagement
//
//  Created by Kra on 5/15/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMPlaylistContentType; 

@interface MMPlaylistSubcontentSelector : UIView 
{
  NSArray *contentGroups;
  IBOutlet UISegmentedControl *segmentedControl;
}

@property (nonatomic, readwrite, retain) NSArray *contentGroups;
@property (nonatomic, readwrite, retain) UISegmentedControl *segmentedControl;

- (MMContentGroup*) selectedContentGroup;

@end
