//
//  MMFieldView.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 9/11/11.
//  Copyright 2011 Edmunds. All rights reserved.
//

#import "MMFieldView.h"
#import "NSString+Converteer.h"

@interface MMFieldView()
@property (nonatomic, readwrite, retain) UITextField *textView;
@end

@implementation MMFieldView

- (void) dealloc 
{
  self.textView = nil;
  [super dealloc];
}

@synthesize textView;

- (void) setValue: (id) value 
{
  if(value == nil)
  {
    textView.text = @"";
    return;
  }
  textView.text = [NSString convert: value];
}

- (NSString *) stringValue 
{
  return textView.text;
}
- (NSNumber *) numberValue
{
  // attempt to conveert string to number
  NSString *value = [self stringValue];

  // no value, return nil
  if([value length] == 0)
  {
    return nil;
  }
  
  NSInteger number = [value integerValue];
  // number is not parseable, return nil
  if(number == 0)
  {
    return nil;
  }
  
  // convert NSInteger to NSNumber
  return [NSNumber numberWithInteger: number];
}

@end
