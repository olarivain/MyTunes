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
@property (nonatomic, readwrite, assign) int port;
@property (nonatomic, readwrite, retain) NSString *host;
@property (nonatomic, readwrite, retain) NSString *name;
@property (nonatomic, readwrite, retain) MMRemoteLibrary *library;
@end

@implementation MMServer
+ (MMServer *) serverWithNetService: (NSNetService*) netService
{
  return [[[MMServer alloc] initWithNetService: netService] autorelease];
}

- (id) initWithNetService: (NSNetService*) service
{
  self = [super init];
  if(self)
  {
    self.netService = service;
    self.library = [MMRemoteLibrary libraryWithServer: self];
  }
  return self;
}

- (void) dealloc
{
  NSLog(@"releasing server with name: %@ %@ %@", name, self, netService);
//  self.netService = nil;
  self.library = nil;
  self.host = nil;
  self.name = nil;
//  [self.netService stop];

  
  [super dealloc];
}

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

@end
