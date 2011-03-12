//
//  QueryCategory.m
//  MediaManagement
//
//  Created by Kra on 3/9/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "QueryCategory.h"
#import "Query.h"
#import "NibUtils.h"

@implementation QueryCategory

- (id) init
{
  self = [super init];
  if(self)
  {
    queries = [[NSMutableArray alloc] initWithCapacity: 5];
  }
  return self;
}

- (void) dealloc
{
  [queries release];
  [super dealloc];
}

@synthesize kind;
@synthesize queries;

@end
