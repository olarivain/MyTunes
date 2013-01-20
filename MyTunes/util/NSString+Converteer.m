//
//  NSString+Converteer.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 9/11/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "NSString+Converteer.h"

@implementation NSString (NSString_Converteer)

+ (NSString *) convert: (id) value {
  // we have a string. Yay!
  if([value isKindOfClass: [NSString class]]) {
    return value;
  }
  
  // convert number
  if([value isKindOfClass: [NSNumber class]]) {
    NSNumber *number = (NSNumber *) value;
    if([number intValue] == 0) 
    {
      return @"";
    }
    return [number stringValue];
  }

  // look for a stringValue selector
  SEL selector = @selector(stringValue);
  if([value respondsToSelector: selector]) {
    return [value stringValue];
  }
  
  // attempt a wild guess
  return [NSString stringWithFormat: @"%@", value];
}

@end
