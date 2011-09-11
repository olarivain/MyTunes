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

@interface MMEditController()
@property (nonatomic, readwrite, retain) NSArray *contentList;
@property (nonatomic, readwrite, retain) UIBarButtonItem *next;
@property (nonatomic, readwrite, retain) UIBarButtonItem *previous;
@property (nonatomic, readwrite, retain) MMLoadingView *loadingView;

- (void) saveWithBlock: (void(^)(void)) block;

@end

@implementation MMEditController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
  self.contentList = nil;
  self.contentGroup = nil;
  self.currentItem= nil;
  self.playlist = nil;
  self.next = nil;
  self.previous = nil;
  self.loadingView = nil;
  
  [super dealloc];
}

@synthesize playlist;
@synthesize contentGroup;
@synthesize currentItem;
@synthesize contentList;
@synthesize next;
@synthesize previous;
@synthesize loadingView;

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
}

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
  [[self parentViewController] dismissModalViewControllerAnimated:TRUE];
}

- (IBAction) save: (id) sender
{
  // call dismiss on callback
  void (^dismiss)(void) = ^{
    [self dismiss];
  };
  
  // first save, then dismiss
  [self saveWithBlock: dismiss];
}

#pragma mark - Save/Cancel
- (void) saveWithBlock: (void(^)(void)) block
{
  // display feedback
  [loadingView setLoading: YES];
  
  // update content item
  [self updateContent];
  
  // remove loading view and process callback
  void (^saveBlock)(void) = ^{
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
  void (^nextBlock)(void) = ^{
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
  void (^previousBlock)(void) = ^{
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
