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

- (id<MMContentEditController>) editControllerForCurrentItem;
- (id<MMContentEditController>) editControllerForKind: (MMContentKind) kind;
- (void) replaceEditViewWithContentKind: (MMContentKind) kind;
@end

@implementation MMEditController_iPad

#pragma mark - View Lifecyle
- (void) viewDidLoad
{
  [super viewDidLoad];
  nameField.inputAccessoryView = previousNextToolbar;
  description.inputAccessoryView = previousNextToolbar;
}
- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear: animated];
  [self updateViewsWithCurrentItem];
}

- (void) viewDidUnload
{
  kindContainer = nil;
  descriptionContainer = nil;
  nameField = nil;
  description = nil;
  showController = nil;
  musicController = nil;
  movieController = nil;
  actionSheet = nil;
  typeButton = nil;
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

- (void) replaceEditViewWithContentKind: (MMContentKind) kind
{
  // first, remove current edit view
  UIView *oldEditView = currentEditController.editView;
  [oldEditView removeFromSuperview];
  
  // update content controller with new content
  currentEditController = [self editControllerForKind: kind];
  [currentEditController setContent: currentItem];
  
  // resize and place content specific view just below kind button
  UIView *editView = currentEditController.editView;
  CGRect editFrame = editView.frame;
  editFrame.origin.y = CGRectGetMaxY(kindContainer.frame);
  editFrame.origin.x = kindContainer.frame.origin.x;
  editFrame.size.width = self.view.frame.size.width - 2 * editFrame.origin.x;
  editView.frame = editFrame;
  
  [self.view addSubview: editView];
  
  // reposition description container appropriately
  CGRect descriptionFrame = descriptionContainer.frame;
  descriptionFrame.origin.y = CGRectGetMaxY(editFrame);
  descriptionContainer.frame = descriptionFrame;

}

- (void) updateViewsWithCurrentItem
{
  // don't forget super
  [super updateViewsWithCurrentItem];

  // replace edit view
  [self replaceEditViewWithContentKind: currentItem.kind];
  
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
  actionSheet = nil;
  
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
  
  // replace edit view
  [self replaceEditViewWithContentKind: currentKind];
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
  actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate: self cancelButtonTitle:nil destructiveButtonTitle: nil otherButtonTitles:nil];

  [actionSheet addButtonWithTitle:@"Music"];
  [actionSheet addButtonWithTitle:@"Movie"];
  [actionSheet addButtonWithTitle:@"TV Show"];
  
  [actionSheet showFromRect: typeButton.frame inView: typeButton.superview animated: YES];

}

@end
