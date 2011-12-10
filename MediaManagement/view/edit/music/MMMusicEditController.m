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
@property (nonatomic, readwrite, strong) UIView *editView;
@property (nonatomic, readwrite, strong) MMFieldView *artistField;
@property (nonatomic, readwrite, strong) MMFieldView *albumField;
@property (nonatomic, readwrite, strong) MMFieldView *trackNumberField;
@property (nonatomic, readwrite, strong) MMFieldView *genreField;
@end

@implementation MMMusicEditController

- (void) dealloc
{
  content = nil;
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
  
  content = newContent;
  
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
