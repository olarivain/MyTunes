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

@interface MMEditController_iPad : MMEditController 
{
  IBOutlet id<MMContentEditController> showController;
  IBOutlet id<MMContentEditController> musicController;
  IBOutlet id<MMContentEditController> movieController;
  
  id<MMContentEditController> currentEditController;
  
  IBOutlet MMContentPlacholder *contentPlaceholder;
  IBOutlet UITextField *nameField;
  IBOutlet UITextView *description;
}

@end
