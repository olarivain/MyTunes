//
//  ContentQuery.m
//  MediaManagement
//
//  Created by Kra on 3/9/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "Query.h"

#import "QueryCategory.h"

@implementation Query

- (void) dealloc
{
  [category release];
  [super dealloc];
}

@synthesize type;
@synthesize category;
@end
