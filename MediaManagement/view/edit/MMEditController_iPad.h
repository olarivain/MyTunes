//
//  MMEditcontroller_iPad.h
//  MediaManagement
//
//  Created by Kra on 5/31/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMEditControllerProtected.h"
#import "MMContentEditController.h"

@class MMContentPlacholder;

@interface MMEditController_iPad : MMEditController<UIActionSheetDelegate>
{
  IBOutlet __strong UIView *previousNextToolbar;
  
  IBOutlet __strong  id<MMContentEditController> showController;
  IBOutlet __strong id<MMContentEditController> musicController;
  IBOutlet __strong id<MMContentEditController> movieController;
  
  __strong id<MMContentEditController> currentEditController;
  
  IBOutlet __strong MMContentPlacholder *contentPlaceholder;
  IBOutlet __strong UITextField *nameField;
  IBOutlet __strong UITextView *description;
  
  IBOutlet __strong UIButton *typeButton;
  
  __strong UIActionSheet *actionSheet;
}

- (IBAction) typePressed;

@end
