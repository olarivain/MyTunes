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
@property (nonatomic, readwrite, retain) UIButton *typeButton;

- (id<MMContentEditController>) editControllerForCurrentItem;
- (id<MMContentEditController>) editControllerForKind: (MMContentKind) kind;

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
  self.typeButton = nil;
  [super dealloc];
}

@synthesize contentPlaceholder;
@synthesize nameField;
@synthesize description;
@synthesize typeButton;
@synthesize showController;
@synthesize musicController;
@synthesize movieController;

#pragma mark - View Lifecyle
- (void) viewDidLoad
{
  [super viewDidLoad];

}
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
  return [self editControllerForKind: currentItem.kind];
}

- (id<MMContentEditController>) editControllerForKind: (MMContentKind) kind
{
  id<MMContentEditController> controller = nil;
  switch (kind) {
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
  [super updateViewsWithCurrentItem];
  // update content controller with new content
  currentEditController = [self editControllerForCurrentItem];
  [currentEditController setContent: currentItem];
  
  // insert content specific view
  [contentPlaceholder setEditView: [currentEditController editView]];
  
  // now start updating ui to reflect changes
  [currentEditController updateContent];
  
  nameField.text = currentItem.name;
  description.text = currentItem.description;
  
  NSString *type = [self kindToString: currentKind];
  [typeButton setTitle: type forState: UIControlStateNormal];
  
  typeButton.enabled = currentKind == MOVIE || currentKind == MUSIC || currentKind == TV_SHOW;
}

- (void) updateContent
{
  [super updateContent];
  currentItem.name = [nameField text];
  currentItem.description = [description text];
  [currentEditController updateContent];
}

- (void) actionSheet:(UIActionSheet *)anActionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  currentKind = buttonIndex;
  
  NSString *type = [self kindToString: currentKind];
  typeButton.titleLabel.text = type;
  [typeButton setTitle: type forState: UIControlStateNormal];
  
  [actionSheet release];
  actionSheet = nil;
  
  // update content controller with new content
  currentEditController = [self editControllerForKind: currentKind];
  [currentEditController setContent: currentItem];
  
  // insert content specific view
  [contentPlaceholder setEditView: [currentEditController editView]];
}

- (IBAction) typePressed
{
  if(actionSheet != nil)
  {
    [actionSheet dismissWithClickedButtonIndex: -1 animated: YES];
    return;
  }
  
  actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate: self cancelButtonTitle:nil destructiveButtonTitle: nil otherButtonTitles:nil];

  [actionSheet addButtonWithTitle:@"Music"];
  [actionSheet addButtonWithTitle:@"Movie"];
  [actionSheet addButtonWithTitle:@"TV Show"];
  
  [actionSheet showFromRect: typeButton.frame inView: typeButton.superview animated: YES];

}

@end
