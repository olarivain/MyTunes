//
//  QueryGroup.m
//  MediaManagement
//
//  Created by Kra on 5/4/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMQueryGroup.h"

#import "MMQuery.h"

@interface MMQueryGroup()


@end
@implementation MMQueryGroup

+ (id) queryGroupWithName: (NSString *) name
{
  return [[[MMQueryGroup alloc] initWithName: name] autorelease];
}
- (id) initWithName: (NSString *) groupName
{
  self = [super init];
  if(self)
  {
    name = [groupName retain];
    queries = [[NSMutableArray alloc] initWithCapacity: 5];
  }
  return self;
}

- (void)dealloc
{
  [name release];
  [queries release];
  [super dealloc];
}

@synthesize name;
@synthesize queries;
@synthesize server;

- (void) addQuery:(MMQuery *)query 
{
  if(![queries containsObject: query])
  {
    [query.group removeQuery: query];
    [queries addObject: query];
    query.group = self;
    query.server = server;
  }
}

- (void) removeQuery:(MMQuery *)query
{
  if([queries containsObject: queries])
  {
    [queries removeObject: query];
    query.group = nil;
    query.server = nil;
  }
}

- (NSInteger) queryCount
{
  return [queries count];
}

@end
