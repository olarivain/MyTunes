//
//  MMEditcontroller_iPad.m
//  MediaManagement
//
//  Created by Kra on 5/31/11.
//  Copyright 2011 kra. All rights reserved.
//


#import <MediaManagement/MMContent.h>
#import "MMEditController_iPad.h"

#import "MMRemotePlaylist.h"
#import "MMContentPlacholder.h"

@interface MMEditController_iPad()
@property (nonatomic, readwrite, retain)  MMContentPlacholder *contentPlaceholder;
@property (nonatomic, readwrite, retain)  UITextField *nameField;
@property (nonatomic, readwrite, retain)  UITextView *description;
@property (nonatomic, readwrite, retain) id<MMContentEditController> showController;
@property (nonatomic, readwrite, retain) id<MMContentEditController> musicController;
@property (nonatomic, readwrite, retain) id<MMContentEditController> movieController;

- (void) updateViewsWithCurrentItem;

@end

@implementation MMEditController_iPad

- (void) dealloc
{
  self.contentPlaceholder = nil;
  self.nameField = nil;
  self.description = nil;
  self.showController = nil;
  self.musicController = nil;
  self.movieController = nil;
  [super dealloc];
}

@synthesize contentPlaceholder;
@synthesize nameField;
@synthesize description;
@synthesize showController;
@synthesize musicController;
@synthesize movieController;

#pragma mark - View Lifecyle
- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear: animated];
  [self updateViewsWithCurrentItem];
}

- (void) viewDidUnload
{
}

- (id<MMContentEditController>) editControllerForCurrentItem
{
  id<MMContentEditController> controller = nil;
  switch (currentItem.kind) {
    case MOVIE:
      controller = movieController;
      break;
    case TV_SHOW:
      controller = showController;
      break;
    case MUSIC:
      controller = musicController;
      break;
    default:
      break;
  }
  return controller;
}

- (void) updateViewsWithCurrentItem
{
  // update content controller with new content
  currentEditController = [self editControllerForCurrentItem];
  [currentEditController setContent: currentItem];
  
  // insert content specific view
  [contentPlaceholder setEditView: [currentEditController editView]];
  
  // now start updating ui to reflect changes
  [currentEditController updateContent];
  
  nameField.text = currentItem.name;
  description.text = currentItem.description;
}

- (IBAction) save:(id)sender
{
  currentItem.name = [nameField text];
  currentItem.description = [description text];
  [currentEditController updateContent];
  
  void (^dismiss)(void) = ^{
    [self dismiss];
  };
  [playlist updateContent: currentItem withBlock: dismiss];
}

@end
