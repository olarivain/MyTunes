//
//  MMEditcontroller_iPad.h
//  MediaManagement
//
//  Created by Kra on 5/31/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMEditController.h"

@interface MMEditController_iPad : MMEditController 
{
  IBOutlet UITextField *nameField;
  IBOutlet UITextField *episodeField;
  IBOutlet UITextField *showField;
  IBOutlet UITextField *seasonField;
  IBOutlet UITextView *description;
}

@end
