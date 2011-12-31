//
//  MMPlaylistSubcontentSelector.h
//  MediaManagement
//
//  Created by Kra on 5/15/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMPlaylistContentType; 

@interface MMPlaylistSubcontentSelector : UIToolbar 
{
  IBOutlet __strong UISegmentedControl *segmentedControl;
  __strong NSArray *contentGroups;
}

@property (nonatomic, readwrite, strong) NSArray *contentGroups;
@property (nonatomic, readwrite, strong) UISegmentedControl *segmentedControl;

- (MMContentGroup*) selectedContentGroup;

@end
