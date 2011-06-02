//
//  MyClass.h
//  MediaManagement
//
//  Created by Kra on 6/1/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMContentEditController.h"

@class MMContent;
@interface MMMusicEditController : NSObject<MMContentEditController> 
{
  MMContent *content;
  IBOutlet UIView *editView;
  IBOutlet UITextField *trackNumberField;    
  IBOutlet UITextField *artistField;
  IBOutlet UITextField *albumField;
}

@end
