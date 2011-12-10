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
@property (nonatomic, readwrite, strong)  MMContentPlacholder *contentPlaceholder;
@property (nonatomic, readwrite, strong)  UITextField *nameField;
@property (nonatomic, readwrite, strong)  UITextView *description;
@property (nonatomic, readwrite, strong) id<MMContentEditController> showController;
@property (nonatomic, readwrite, strong) id<MMContentEditController> musicController;
@property (nonatomic, readwrite, strong) id<MMContentEditController> movieController;
@property (nonatomic, readwrite, strong) UIButton *typeButton;
@property (nonatomic, readwrite, strong) UIActionSheet *actionSheet;

- (id<MMContentEditController>) editControllerForCurrentItem;
- (id<MMContentEditController>) editControllerForKind: (MMContentKind) kind;

@end

@implementation MMEditController_iPad


@synthesize contentPlaceholder;
@synthesize nameField;
@synthesize description;
@synthesize typeButton;
@synthesize showController;
@synthesize musicController;
@synthesize movieController;
@synthesize actionSheet;

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
  self.contentPlaceholder = nil;
  self.nameField = nil;
  self.description = nil;
  self.showController = nil;
  self.musicController = nil;
  self.movieController = nil;
  self.actionSheet = nil;
  self.typeButton = nil;
  [super viewDidUnload];
}

// returns the relevant edit controller for the current item
- (id<MMContentEditController>) editControllerForCurrentItem
{
  return [self editControllerForKind: currentItem.kind];
}

// returns the relevant edit controller for given content kind
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
  // don't forget super
  [super updateViewsWithCurrentItem];
  
  // update content controller with new content
  currentEditController = [self editControllerForCurrentItem];
  [currentEditController setContent: currentItem];
  
  // insert content specific view
  [contentPlaceholder setEditView: [currentEditController editView]];
  
  // now start updating ui to reflect changes
  [currentEditController updateContent];
  
  // inject values into views
  nameField.text = currentItem.name;
  description.text = currentItem.description;
  
  NSString *type = [self kindToString: currentKind];
  [typeButton setTitle: type forState: UIControlStateNormal];
  
  typeButton.enabled = currentKind == MOVIE || currentKind == MUSIC || currentKind == TV_SHOW;
}

- (void) updateContent
{
  [super updateContent];
  // update view
  currentItem.name = [nameField text];
  currentItem.description = [description text];
  // and forward to kind specific controller
  [currentEditController updateContent];
}

- (void) actionSheet:(UIActionSheet *)anActionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  // get rid of the action sheet first thing
  self.actionSheet = nil;
  
  // value is nonsensical, user tapped out of action sheet, bail out.
  if(buttonIndex < 0) {
    return;
  }
  
  // save kind if button value is relevant. button are sorted just like the kinds :)
  currentKind = buttonIndex;
  
  // update view
  NSString *type = [self kindToString: currentKind];
  typeButton.titleLabel.text = type;
  [typeButton setTitle: type forState: UIControlStateNormal];
  
  // update content controller with new content
  currentEditController = [self editControllerForKind: currentKind];
  [currentEditController setContent: currentItem];
  
  // insert content specific view
  [contentPlaceholder setEditView: [currentEditController editView]];
}

- (IBAction) typePressed
{
  // dismiss current action sheet if user pressed the button again
  if(actionSheet != nil)
  {
    [actionSheet dismissWithClickedButtonIndex: -1 animated: YES];
    return;
  }
  
  // otherwise, create a new one
  self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate: self cancelButtonTitle:nil destructiveButtonTitle: nil otherButtonTitles:nil];

  [actionSheet addButtonWithTitle:@"Music"];
  [actionSheet addButtonWithTitle:@"Movie"];
  [actionSheet addButtonWithTitle:@"TV Show"];
  
  [actionSheet showFromRect: typeButton.frame inView: typeButton.superview animated: YES];

}

@end
