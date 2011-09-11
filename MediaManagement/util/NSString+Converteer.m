//
//  NSString+Converteer.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 9/11/11.
//  Copyright 2011 Edmunds. All rights reserved.
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
    return [(NSNumber *) value stringValue];
  }

  // look for a stringValue selector
  SEL selector = @selector(stringValue);
  if([value respondsToSelector: selector]) {
    return [value performSelector: selector];
  }
  
  // attempt a wild guess
  return [NSString stringWithFormat: @"%@", value];
}

@end
