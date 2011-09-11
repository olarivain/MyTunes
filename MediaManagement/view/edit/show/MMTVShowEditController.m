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

@property (nonatomic, readwrite, retain)  UIView *editView;
@property (nonatomic, readwrite, retain)  MMFieldView *episodeField;
@property (nonatomic, readwrite, retain)  MMFieldView *showField;
@property (nonatomic, readwrite, retain)  MMFieldView *seasonField;

@end

@implementation MMTVShowEditController

- (void) dealloc
{
  self.editView = nil;
  self.episodeField = nil;
  self.showField = nil;
  self.seasonField = nil;
  self.content = nil;
  [super dealloc];
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
  
  [content release];
  content = [newContent retain];
  
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
