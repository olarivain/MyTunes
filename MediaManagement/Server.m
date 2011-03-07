//
//  iServer.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Server.h"


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
  [netService stop];
  [netService release];
  [super dealloc];
}

@synthesize netService;

- (int) port
{
  return [netService port];
}

- (NSString*) hostname
{
  return [netService hostName];
}

- (NSString *) name
{
  NSString *hostname = [self hostname];
  return [[hostname componentsSeparatedByString:@".local"] objectAtIndex:0];
}

- (void) resolve
{
  [netService resolveWithTimeout:5];
}

@end
