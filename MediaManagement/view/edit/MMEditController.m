//
//  EditController.m
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <MediaManagement/MMContentGroup.h>

#import "MMEditControllerProtected.h"
#import "MMRemotePlaylist.h"
#import "MMLoadingView.h"

typedef void(^MMEditControllerCallback)(void);

@interface MMEditController()
@property (nonatomic, readwrite, strong) NSArray *contentList;

- (void) saveWithBlock: (MMEditControllerCallback) block;

@end

@implementation MMEditController

@synthesize playlist;
@synthesize contentGroup;
@synthesize currentItem;
@synthesize contentList;
@synthesize delegate;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.contentList = [contentGroup allContent];
  if(currentItem == nil && [contentList count] > 0)
  {
    self.currentItem = [contentList objectAtIndex: 0];
  }
  
  currentIndex = [contentList indexOfObject: currentItem];
  [self updateViewsWithCurrentItem];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return YES;
}

#pragma mark - Dismissal
- (void) dismiss
{
  [self.presentingViewController dismissModalViewControllerAnimated:TRUE];
}

- (IBAction) save: (id) sender
{
  // call dismiss on callback
  MMEditControllerCallback dismiss = ^{
    [self dismiss];
  };
  
  // first save, then dismiss
  [self saveWithBlock: dismiss];
}

#pragma mark - Save/Cancel
- (void) saveWithBlock: (MMEditControllerCallback) block
{
  // display feedback
  [loadingView setLoading: YES];
  
  // update content item
  [self updateContent];
  
  // remove loading view and process callback
  MMPlaylistCallback saveBlock = ^{
    [delegate didEditContent: currentItem];
    [loadingView setLoading: NO];
    block();
  };
  
  // tell playlist to update its content
  [playlist updateContent: currentItem withBlock: saveBlock];
}

- (IBAction) cancel: (id) sender
{
  // just dismiss
  [self dismiss];  
}

- (IBAction) next: (id) sender
{
  // move view to next content item on callback
  MMEditControllerCallback nextBlock = ^{
    currentIndex++;
    self.currentItem = [contentList objectAtIndex: currentIndex];
    [self updateViewsWithCurrentItem];
  };
  
  // save
  [self saveWithBlock: nextBlock];
}

- (IBAction) previous: (id) sender
{
  // move view to previous item on callback
  MMEditControllerCallback previousBlock = ^{
    currentIndex--;
    self.currentItem = [contentList objectAtIndex: currentIndex];
    [self updateViewsWithCurrentItem];
  };
  
  // and save!
  [self saveWithBlock: previousBlock];
}

// this is the only part common to all controllers, so do it here
- (void) updateContent
{
  currentItem.kind = currentKind;
}

- (void) updateViewsWithCurrentItem
{
  // enable next/previous buttons depending on position
  next.enabled = currentItem != [contentList lastObject];
  previous.enabled = currentIndex > 0;
  // update current kind
  currentKind = currentItem.kind;
}

// converts kinds enums to string
- (NSString*) kindToString: (MMContentKind) kind
{
  switch (kind) {
    case MOVIE:
      return @"Movie";
    case MUSIC:
      return @"Music";
    case TV_SHOW:
      return @"TV Show";
    case PODCAST:
      return @"Podcast";
    case ITUNES_U:
      return @"iTunes U";
    case BOOKS:
      return @"Book";      
    default:
      break;
  }
  return @"Unknown";
}

@end
