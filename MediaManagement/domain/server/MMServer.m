//
//  iServer.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//


#import <MediaManagement/MMContent.h>

#import "MMServer.h"

#import "MMQueryGroup.h"
#import "MMQuery.h"

@interface MMServer()
- (void) bootstrapQueries;
@end

@implementation MMServer

- (id) initWithNetService: (NSNetService*) service
{
  self = [super init];
  if(self)
  {
    netService = [service retain];
    queryGroups = [[NSMutableArray alloc] initWithCapacity:5];
    [self bootstrapQueries];
  }
  return self;
}

- (void) dealloc
{
  [queryGroups release];
  [host release];
  [name release];
  
  [netService stop];
  [netService release];
  [super dealloc];
}

@synthesize netService;
@synthesize name;
@synthesize port;
@synthesize host;
@synthesize queryGroups;

#pragma mark - Query management
- (void) bootstrapQueries
{
  MMQueryGroup *library = [MMQueryGroup queryGroupWithName:@"Library"];
  library.server = self;
  [MMQuery queryWithName:@"Music" path:@"/music" andGroup:library];
  [MMQuery queryWithName:@"Movies" path:@"/movies" andGroup:library];
  [MMQuery queryWithName:@"TV Shows" path:@"/shows" andGroup:library];
  [MMQuery queryWithName:@"Podcasts" path:@"/podcasts" andGroup:library];
  [MMQuery queryWithName:@"iTunes U" path:@"/itunesu" andGroup:library];
  [queryGroups addObject: library];
  
  MMQueryGroup *user = [MMQueryGroup  queryGroupWithName:@"Playlists"];
  user.server = self;
  [queryGroups addObject: user];
}

- (void) didResolve
{
  port = [netService port];
  if(host)
  {
    [host release];
  }
  
  host = [netService hostName];
  if(name)
  {
    [name release];
  }
  name = [[[host componentsSeparatedByString:@".local"] objectAtIndex:0] retain];
}

- (NSString*) serverURL
{
  return [NSString stringWithFormat:@"http://%@:%i", host, port];
}

@end
