//
//  Servers.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "Servers.h"
#import "Server.h"

@interface Servers(private)
- (Server*) pendingServerWithNetService: (NSNetService*) netService;
- (Server*) serverWithNetService: (NSNetService*) netService;
- (Server*) serverWithNetService: (NSNetService*) netService inCollection: (NSArray*) serverList;
@end

@implementation Servers

- (id) init
{
  self = [super init];
  if(self)
  {
    netServiceBrowser = [[NSNetServiceBrowser alloc] init];
    [netServiceBrowser setDelegate: self];
    
    pendingServers = [[NSMutableArray alloc] init];
    servers = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void) dealloc
{
  [netServiceBrowser stop];
  [netServiceBrowser release];
  
  [pendingServers release];
  [servers release];
  [self dealloc];
}

@synthesize servers;
@synthesize delegate;

#pragma mark - Server access methods

- (void) startSearch
{
  [netServiceBrowser searchForServicesOfType:@"_http._tcp" inDomain:@"local."];
}

- (void) refreshServerList
{
  [netServiceBrowser stop];
  [netServiceBrowser searchForServicesOfType:@"_http._tcp" inDomain:@"local."];
}

- (Server*) pendingServerWithNetService: (NSNetService*) netService
{
  return [self serverWithNetService:netService inCollection:pendingServers];
}

- (Server*) serverWithNetService: (NSNetService*) netService
{
  return [self serverWithNetService:netService inCollection:servers];  
}


- (Server*) serverWithNetService: (NSNetService*) netService inCollection: (NSArray*) serverList
{
  for(Server *server in serverList)
  {
    if([[[server netService] name] isEqualToString: [netService name]])
    {
      return server;
    }
  }
  return nil;
}

#pragma mark - NSNetServiceBrowserDelegate methods
- (void) netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
  if(![[aNetService name] hasPrefix:@"iServe-"])
  {
    return;
  }
  NSLog(@"Found service.");

  Server *server = [[[Server alloc] initWithNetService: aNetService] autorelease];
  [pendingServers addObject: server];
  [aNetService setDelegate: self];
  [aNetService resolveWithTimeout:5];
}

- (void) netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
  NSLog(@"Service removed.");
  
  Server *server = [self serverWithNetService: aNetService];
  [servers removeObject: server];
  [[self delegate] didRefresh:self];
}

- (void) netServiceBrowserWillSearch:(NSNetServiceBrowser *)aNetServiceBrowser
{
  [servers removeAllObjects];
  [pendingServers removeAllObjects];
  
  if([[delegate class] respondsToSelector: @selector(willRefresh:)])
  {
    [delegate willRefresh:self];
  }

}

#pragma mark - NSNetService delegate methods
- (void) netServiceDidResolveAddress:(NSNetService *)sender
{
  NSLog(@"Did resolve service.");
  Server *server = [self pendingServerWithNetService: sender];
  [server didResolve];
  [servers addObject: server];
  [pendingServers removeObject: server];

  [[self delegate] didRefresh: self];
}

- (void) netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
  NSLog(@"Did not resolve service.");
  
  Server *server = [self pendingServerWithNetService: sender];
  [pendingServers removeObject: server];
  [[self delegate] didRefresh: self];
}


@end
