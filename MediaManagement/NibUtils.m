//
//  NibUtils.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "NibUtils.h"

static NSString *deviceSuffix;

@interface NibUtils(private)
+ (NSString*) deviceSuffix;
@end
@implementation NibUtils

+ (NSString*) deviceSuffix
{
  if(deviceSuffix == nil)
  {
    deviceSuffix =   UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"_iPad"  : @"_iPhone";
    [deviceSuffix retain];
  }
  
  return deviceSuffix;

}

+ (NSString*) nibName: (NSString*) name
{
  return [NSString stringWithFormat:@"%@%@", name, [NibUtils deviceSuffix]];
}
@end
