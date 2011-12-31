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
  IBOutlet __strong UIView *previousNextToolbar;
  IBOutlet __strong UIView *editView;
  IBOutlet __strong MMFieldView *episodeField;
  IBOutlet __strong MMFieldView *showField;
  IBOutlet __strong MMFieldView *seasonField;
  
  __strong MMContent *content;
}

@property (nonatomic, readwrite, strong)  UIView *editView;

@end
