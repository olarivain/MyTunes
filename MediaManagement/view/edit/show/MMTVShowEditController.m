//
//  MMTVShowEditView.m
//  MediaManagement
//
//  Created by Kra on 6/1/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <MediaManagement/MMContent.h>

#import "MMTVShowEditController.h"
#import "MMFieldView.h"


@interface MMTVShowEditController()

@property (nonatomic, readwrite, strong)  UIView *editView;
@property (nonatomic, readwrite, strong)  MMFieldView *episodeField;
@property (nonatomic, readwrite, strong)  MMFieldView *showField;
@property (nonatomic, readwrite, strong)  MMFieldView *seasonField;

@end

@implementation MMTVShowEditController

- (void) dealloc
{
  content = nil;
}

@synthesize editView;
@synthesize episodeField;
@synthesize showField;
@synthesize seasonField;

- (void) setContent: (MMContent*) newContent
{
  if(newContent == content) {
    return;
  }
  
  content = newContent;
  
  [showField setValue: content.show];
  [episodeField setValue: content.episodeNumber];
  [seasonField setValue: content.season];
}

- (void) updateContent
{
  
  content.show = [showField stringValue];
  content.episodeNumber = [episodeField numberValue];
  content.season = [seasonField numberValue];
}

@end
