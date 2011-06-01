//
//  EditController.h
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMContentGroup;
@class MMContent;
@class MMPlaylist;

@interface MMEditController : UIViewController 
{
  MMPlaylist *playlist;
  MMContentGroup *contentGroup;
  MMContent *currentItem;
}

@property (nonatomic, readwrite, retain) MMPlaylist *playlist;
@property (nonatomic, readwrite, retain) MMContentGroup *contentGroup;
@property (nonatomic, readwrite, retain) MMContent *currentItem;

- (IBAction) save: (id) sender;
- (IBAction) cancel: (id) sender;
- (void) dismiss;

@end
