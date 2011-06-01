//
//  MMEditcontroller_iPad.m
//  MediaManagement
//
//  Created by Kra on 5/31/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMEditController_iPad.h"
#import <MediaManagement/MMContent.h>
#import "MMRemotePlaylist.h"

@interface MMEditController_iPad()
@property (nonatomic, readwrite, retain)  UITextField *nameField;
@property (nonatomic, readwrite, retain)  UITextField *episodeField;
@property (nonatomic, readwrite, retain)  UITextField *showField;
@property (nonatomic, readwrite, retain)  UITextField *seasonField;
@property (nonatomic, readwrite, retain)  UITextView *description;
@end

@implementation MMEditController_iPad

- (void) dealloc
{
  self.nameField = nil;
  self.episodeField = nil;
  self.showField = nil;
  self.seasonField = nil;
  self.description = nil;
  [super dealloc];
}

@synthesize nameField;
@synthesize episodeField;
@synthesize showField;
@synthesize seasonField;
@synthesize description;

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear: animated];
  
  nameField.text = currentItem.name;
  episodeField.text = [currentItem.episodeNumber stringValue];
  showField.text = currentItem.show;
  seasonField.text = [currentItem.season stringValue];
  description.text = currentItem.description;
}

- (void) viewDidUnload
{
  self.nameField = nil;
  self.episodeField = nil;
  self.showField = nil;
  self.seasonField = nil;
  self.description = nil;
}

- (IBAction) save:(id)sender
{
  currentItem.name = [nameField text];
  currentItem.show = [showField text];
  currentItem.description = [description text];
  
  NSString *episodeValue = [episodeField text];
  NSNumber *episodeNumber = [NSNumber numberWithInt: [episodeValue intValue]];
  currentItem.episodeNumber = episodeNumber;
  
  NSString *seasonValue = [seasonField text];
  NSNumber *seasonNumber = [NSNumber numberWithInt: [seasonValue intValue]];
  currentItem.season = seasonNumber;
  
  void (^dismiss)(void) = ^{
    [self dismiss];
  };
  [playlist updateContent: currentItem withBlock: dismiss];
}

@end
