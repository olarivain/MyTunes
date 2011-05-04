//
//  iServer.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "Server.h"
#import <MediaManagement/MMContent.h>

@implementation Server

- (id) initWithNetService: (NSNetService*) service
{
  self = [super init];
  if(self)
  {
    netService = [service retain];
  }
  return self;
}

- (void) dealloc
{
  [songs release];
  [movies release];
  [tvShows release];
  [podcasts release];
  [itunesU release];
 
  [host release];
  [name release];
  
  [netService stop];
  [netService release];
  [super dealloc];
}

@synthesize netService;
@synthesize songs;
@synthesize movies;
@synthesize tvShows;
@synthesize podcasts;
@synthesize itunesU;
@synthesize name;
@synthesize port;
@synthesize host;


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

- (void) loadContent: (MMContentKind) kind 
{
  // TODO: implement
  NSLog(@"loadContent not implemented.");
}

@end
