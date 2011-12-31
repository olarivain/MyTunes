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
  IBOutlet __strong UIView *previousNextToolbar;
  IBOutlet __strong UIView *editView;
  IBOutlet __strong MMFieldView *trackNumberField;    
  IBOutlet __strong MMFieldView *artistField;
  IBOutlet __strong MMFieldView *albumField;
  IBOutlet __strong MMFieldView *genreField;
}

@end
