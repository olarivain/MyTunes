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

@interface MMServer()
@property (nonatomic, readwrite, retain) NSNetService *netService;
@end

@implementation MMServer

- (id) initWithNetService: (NSNetService*) service
{
  self = [super init];
  if(self)
  {
    self.netService = service;
    library = [[MMRemoteLibrary alloc] initWithServer: self];
  }
  return self;
}

- (void) dealloc
{
  NSLog(@"releasing server with name: %@ %@ %@", name, self, netService);
  [library release];
  [host release];
  [name release];
  
  [netService stop];
  self.netService = nil;
  [super dealloc];
}

//@synthesize netService;
@synthesize name;
@synthesize port;
@synthesize host;
@synthesize library;
@synthesize netService;

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

- (void) stop
{
  [netService stop];
}

@end
