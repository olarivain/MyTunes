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
@property (nonatomic, readwrite, retain) UIView *editView;
@property (nonatomic, readwrite, retain) MMFieldView *artistField;
@property (nonatomic, readwrite, retain) MMFieldView *albumField;
@property (nonatomic, readwrite, retain) MMFieldView *trackNumberField;
@property (nonatomic, readwrite, retain) MMFieldView *genreField;
@end

@implementation MMMusicEditController

- (void) dealloc
{
  self.editView = nil;
  self.artistField = nil;
  self.albumField = nil;
  self.trackNumberField = nil;
  self.genreField = nil;
  self.content = nil;
  [super dealloc];
}

@synthesize editView;
@synthesize artistField;
@synthesize albumField;
@synthesize trackNumberField;
@synthesize genreField;

- (void) setContent:(MMContent *) newContent
{
  if(newContent == content) {
    return;
  }
  
  [content release];
  content = [newContent retain];
  
  [albumField setValue: content.album];
  [artistField setValue: content.artist];
  [trackNumberField setValue: content.trackNumber];
  [genreField setValue: content.genre];
}

- (void) updateContent
{
  content.album = [albumField stringValue];
  content.artist = [artistField stringValue];
  content.trackNumber = [trackNumberField numberValue];
  content.genre = [genreField stringValue];
}

@end
