//
//  MyClass.m
//  MediaManagement
//
//  Created by Kra on 6/1/11.
//  Copyright 2011 kra. All rights reserved.
//
#import <MediaManagement/MMContent.h>
#import "MMMusicEditController.h"
#import "MMFieldView.h"

@interface MMMusicEditController()
@property (nonatomic, readwrite, retain)  UIView *editView;
@property (nonatomic, readwrite, retain)  MMFieldView *artistField;
@property (nonatomic, readwrite, retain)  MMFieldView *albumField;
@property (nonatomic, readwrite, retain)  MMFieldView *trackNumberField;
@end

@implementation MMMusicEditController

- (void) dealloc
{
  self.editView = nil;
  self.artistField = nil;
  self.albumField = nil;
  self.trackNumberField = nil;
  [content release];
  content = nil;
  [super dealloc];
}

@synthesize editView;
@synthesize artistField;
@synthesize albumField;
@synthesize trackNumberField;

- (void) setContent:(MMContent *) newContent
{
  if(newContent == content) {
    return;
  }
  
  [content release];
  content = [newContent retain];
  
  content = newContent;
  [albumField setValue: content.album];
  [artistField setValue: content.artist];
  [trackNumberField setValue: content.trackNumber];
}

- (void) updateContent
{
  content.album = [albumField stringValue];
  content.artist = [artistField stringValue];
  content.trackNumber = [trackNumberField numberValue];
}

@end
