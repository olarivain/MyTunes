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
@class MMFieldView;

@interface MMMusicEditController : NSObject<MMContentEditController> 
{
  MMContent *content;
  IBOutlet UIView *editView;
  IBOutlet MMFieldView *trackNumberField;    
  IBOutlet MMFieldView *artistField;
  IBOutlet MMFieldView *albumField;
  IBOutlet MMFieldView *genreField;
}

@end
