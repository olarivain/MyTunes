//
//  MMTitleDetailCellSize.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 1/1/12.
//  Copyright (c) 2012 Edmunds. All rights reserved.
//

#import "MMTitleDetailCellSize.h"

@implementation MMTitleDetailCellSize

+ (MMTitleDetailCellSize *) titleDetailCellSize
{
  return [[MMTitleDetailCellSize alloc] init];
}

- (id) init
{
  self = [super init];
  if(self)
  {
    audioTracksHeight = 0.0f;
    subtitleTracksHeight = 0.0f;
    totalHeight = 0.0f;
  }
  return self;
}

@synthesize audioTracksHeight;
@synthesize subtitleTracksHeight;
@synthesize totalHeight;

@end
