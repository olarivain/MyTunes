//
//  iServer.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Server.h"


@implementation Server

- (id) initWithHostName: (NSString*) host andPort: (int) serverPort
{
  self = [super init];
  if(self)
  {
    hostname = [host retain];
    port = serverPort;
  }
  return self;
}

- (void) dealloc
{
  [hostname release];
  [super dealloc];
}

@synthesize hostname;
@synthesize port;

- (NSString *) name
{
  return hostname;
}

@end
