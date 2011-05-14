//
//  iServer.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//


#import <MediaManagement/MMContent.h>

#import "MMServer.h"
#import "MMRemoteLibrary.h"
#import "MMQuery.h"

@implementation MMServer

- (id) initWithNetService: (NSNetService*) service
{
  self = [super init];
  if(self)
  {
    netService = [service retain];
    serverLibrary = [[MMRemoteLibrary alloc] initWithServer: self];
  }
  return self;
}

- (void) dealloc
{
  [serverLibrary release];
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
@synthesize serverLibrary;

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

- (void) loadLibrary
{

}

@end
