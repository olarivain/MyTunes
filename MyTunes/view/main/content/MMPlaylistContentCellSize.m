//
//  MMPlaylistContentCellSize.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 kra. All rights reserved.
//

#import "MMPlaylistContentCellSize.h"

@implementation MMPlaylistContentCellSize

+ (MMPlaylistContentCellSize *) playlistContentCellSize
{
  return [[MMPlaylistContentCellSize alloc] init];
}

- (id) init
{
  self = [super init];
  if(self)
  {
    nameSize = CGSizeZero;
    totalHeight = 0.0f;
  }
  return self;
}

@synthesize nameSize;
@synthesize totalHeight;

@end
