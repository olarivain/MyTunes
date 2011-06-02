//
//  MyClass.m
//  MediaManagement
//
//  Created by Kra on 6/1/11.
//  Copyright 2011 kra. All rights reserved.
//
#import <MediaManagement/MMContent.h>
#import "MMMusicEditController.h"

@interface MMMusicEditController()
@property (nonatomic, readwrite, retain)  UIView *editView;
@property (nonatomic, readwrite, retain)  UITextField *artistField;
@property (nonatomic, readwrite, retain)  UITextField *albumField;
@property (nonatomic, readwrite, retain)  UITextField *trackNumberField;
@end

@implementation MMMusicEditController

- (void) dealloc
{
  self.editView = nil;
  self.artistField = nil;
  self.albumField = nil;
  self.trackNumberField = nil;
  [super dealloc];
}

@synthesize editView;
@synthesize artistField;
@synthesize albumField;
@synthesize trackNumberField;

- (void) setContent:(MMContent *) newContent
{
  content = newContent;
  albumField.text = content.album;
  artistField.text = content.artist;
  
  NSInteger track = [content.trackNumber intValue];
  trackNumberField.text = track == 0 ? @"" : [content.trackNumber stringValue];
}

- (void) updateContent
{
  content.album = albumField.text;
  content.artist = artistField.text;
  
  NSString *trackValue = [trackNumberField text];
  if([trackValue length] > 0)
  {
    NSInteger track = [trackValue intValue];
    content.trackNumber = [NSNumber numberWithInt: track];
  }
}

@end
