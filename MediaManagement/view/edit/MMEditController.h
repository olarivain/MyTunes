//
//  EditController.h
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaManagement/MMContent.h>

@class MMContentGroup;
@class MMPlaylist;
@class MMLoadingView;

@interface MMEditController : UIViewController 
{
  MMPlaylist *playlist;
  MMContentGroup *contentGroup;
  MMContent *currentItem;
  NSArray *contentList;
  NSUInteger currentIndex;
  
  IBOutlet UIBarButtonItem *next;
  IBOutlet UIBarButtonItem *previous;
  IBOutlet MMLoadingView *loadingView;
  
  MMContentKind currentKind;
}

@property (nonatomic, readwrite, retain) MMPlaylist *playlist;
@property (nonatomic, readwrite, retain) MMContentGroup *contentGroup;
@property (nonatomic, readwrite, retain) MMContent *currentItem;

- (IBAction) save: (id) sender;
- (IBAction) cancel: (id) sender;
- (void) dismiss;

@end
