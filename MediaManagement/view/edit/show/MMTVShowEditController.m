//
//  MMTVShowEditView.m
//  MediaManagement
//
//  Created by Kra on 6/1/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMTVShowEditController.h"
#import <MediaManagement/MMContent.h>

@interface MMTVShowEditController()

@property (nonatomic, readwrite, retain)  UIView *editView;
@property (nonatomic, readwrite, retain)  UITextField *episodeField;
@property (nonatomic, readwrite, retain)  UITextField *showField;
@property (nonatomic, readwrite, retain)  UITextField *seasonField;

@end

@implementation MMTVShowEditController

- (void) dealloc
{
  self.editView = nil;
  self.episodeField = nil;
  self.showField = nil;
  self.seasonField = nil;
  [super dealloc];
}

@synthesize editView;
@synthesize episodeField;
@synthesize showField;
@synthesize seasonField;

- (void) updateContent
{
  content.show = [showField text];
  NSString *episodeValue = [episodeField text];
  NSNumber *episodeNumber = [NSNumber numberWithInt: [episodeValue intValue]];
  content.episodeNumber = episodeNumber;
  
  NSString *seasonValue = [seasonField text];
  NSNumber *seasonNumber = [NSNumber numberWithInt: [seasonValue intValue]];
  content.season = seasonNumber;
}

- (void) setContent: (MMContent*) newContent
{
  content = newContent;
  
  showField.text = content.show;
  
  NSInteger episodeValue = [content.episodeNumber intValue];
  episodeField.text = episodeValue != 0 ? [content.episodeNumber stringValue] : @"";
  
  NSInteger seasonValue = [content.season intValue];
  seasonField.text = seasonValue != 0 ? [content.season stringValue] : @"";
}

@end
