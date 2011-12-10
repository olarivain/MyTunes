//
//  MMTVShowEditView.h
//  MediaManagement
//
//  Created by Kra on 6/1/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMContentEditController.h"

@class MMContent;
@class MMFieldView;

@interface MMTVShowEditController : NSObject<MMContentEditController> 
{
  IBOutlet UIView *editView;
  IBOutlet MMFieldView *episodeField;
  IBOutlet MMFieldView *showField;
  IBOutlet MMFieldView *seasonField;
  
  MMContent *__strong content;
}

@end
