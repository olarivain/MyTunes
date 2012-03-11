//
//  MMTitleAssembler+Client.m
//  MediaManagement
//
//  Created by Olivier Larivain on 3/10/12.
//  Copyright (c) 2012 kra. All rights reserved.
//
#import <MediaManagement/MMTitle.h>
#import <MediaManagement/MMTitleList.h>
#import "MMTitleAssembler+Client.h"

@implementation MMTitleAssembler (Client)

- (void) updateTitleStatus: (MMTitleList *) titleList withDto: (NSDictionary *) dto
{
  NSArray *titleDtos = [dto nullSafeForKey: @"titles"];
  for(NSDictionary *titleDto in titleDtos)
  {
    NSInteger titleIndex = [titleDto integerForKey: @"index"];
    MMTitle *title = [titleList titleWithIndex: titleIndex];
    
    title.eta = [titleDto integerForKey: @"eta"];
    title.progress = [titleDto integerForKey: @"progress"];
    title.completed = [titleDto booleanForKey: @"completed"];
  }
}

@end
