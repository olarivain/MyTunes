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

- (void) saveWithBlock: (void(^)(void)) block userFeedback: (BOOL) feedback;
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

#pragma mark - Action Handler
- (void) dismiss
{
  [[self parentViewController] dismissModalViewControllerAnimated:TRUE];
}
- (IBAction) save: (id) sender
{
  void (^dismiss)(void) = ^{
    [self dismiss];
  };
  [self saveWithBlock: dismiss userFeedback: YES];
}

- (void) saveWithBlock: (void(^)(void)) block userFeedback: (BOOL) feedback
{
  if(feedback)
  {
    [loadingView setLoading: YES];
  }
  
  [self updateContent];
  
  void (^saveBlock)(void) = ^{
    if(feedback)
    {
      [loadingView setLoading: NO];
    }
    block();
  };
  
  [playlist updateContent: currentItem withBlock: saveBlock];
}

- (IBAction) cancel: (id) sender
{
  [self dismiss];  
}

- (IBAction) next: (id) sender
{
  void (^nextBlock)(void) = ^{
    currentIndex++;
    self.currentItem = [contentList objectAtIndex: currentIndex];
    [self updateViewsWithCurrentItem];
  };
  
  [self saveWithBlock: nextBlock userFeedback: NO];
}

- (IBAction) previous: (id) sender
{
  void (^previousBlock)(void) = ^{
    currentIndex--;
    self.currentItem = [contentList objectAtIndex: currentIndex];
    [self updateViewsWithCurrentItem];
  };
  
  [self saveWithBlock: previousBlock userFeedback: NO];
}

- (void) updateContent
{
  NSLog(@"FATAL: subclasses must override MMEditController.updateContent");
}

- (void) updateViewsWithCurrentItem
{
  next.enabled = currentItem != [contentList lastObject];
  previous.enabled = currentIndex > 0;
}

@end
