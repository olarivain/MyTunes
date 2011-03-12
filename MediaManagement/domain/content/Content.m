//
//  Content.m
//  MediaManagement
//
//  Created by Kra on 3/9/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "Content.h"


@implementation Content

- (void) dealloc
{
  [name release];
  [show release];
  [description release];
  [thumbnail release];
  [super dealloc];
}

@synthesize name;
@synthesize description;
@synthesize genre;
@synthesize thumbnail;
@synthesize kind;
@synthesize show;
@synthesize order;
@synthesize season;


@end
