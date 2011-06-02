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

@interface MMTVShowEditController : NSObject<MMContentEditController> 
{
  IBOutlet UIView *editView;
  IBOutlet UITextField *episodeField;
  IBOutlet UITextField *showField;
  IBOutlet UITextField *seasonField;
  
  MMContent *content;
}

@end
