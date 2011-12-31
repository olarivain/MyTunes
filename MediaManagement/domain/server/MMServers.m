//
//  Servers.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMServers.h"
#import "MMServer.h"

@interface MMServers()
- (MMServer *) serverWithNetService: (NSNetService *) netService;
@end

@implementation MMServers

- (id) init
{
  self = [super init];
  if(self)
  {
    netServiceBrowser = [[NSNetServiceBrowser alloc] init];
    netServiceBrowser.delegate = self;
    
    netServices = [NSMutableArray arrayWithCapacity:5];
    
    servers = [NSMutableArray array];
  }
  return self;
}

- (void) dealloc
{
  [netServiceBrowser stop];
}

@synthesize servers;
@synthesize delegate;

#pragma mark - Server access methods

- (void) startSearch
{
  if(didStartSearch)
  {
    return;
  }
  
  didStartSearch = YES;
  [netServiceBrowser searchForServicesOfType:@"_http._tcp" inDomain:@"local."];
}

- (MMServer *) serverWithNetService: (NSNetService *) netService
{
  for(MMServer *server in servers)
  {
    if([server.key isEqual: netService.name])
    {
      return server;
    }
  }
  return nil;
}


#pragma mark - NSNetServiceBrowserDelegate methods
- (void) netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
  if(![aNetService.name hasPrefix:@"iServe-"])
  {
    return;
  }
  
  NSLog(@"Found service %@.", aNetService.name);

  [netServices addObject: aNetService];
  
  aNetService.delegate = self;
  [aNetService resolveWithTimeout:5];
}

- (void) netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
  NSLog(@"Service %@ removed.", aNetService.name);
  
  // net service disappeared, first remove any server associated
  MMServer *removed = [self serverWithNetService: aNetService];
  [servers removeObject: removed];
  
  // drop net service
  aNetService.delegate = nil;
  [netServices removeObject: aNetService];
  
  // notify delegate
  [delegate didRefresh:self];
}

- (void) netServiceBrowserWillSearch:(NSNetServiceBrowser *)aNetServiceBrowser
{
  if([[delegate class] respondsToSelector: @selector(willRefresh:)])
  {
    [delegate willRefresh:self];
  }

}

#pragma mark - NSNetService delegate methods
- (void) netServiceDidResolveAddress:(NSNetService *)aNetService
{
  NSLog(@"Resolved service %@:\nhttp://%@:%i", aNetService.name, aNetService.hostName, aNetService.port);

  // service did resolve properly, build server with hostname/port, add to list and notify delegate
  MMServer *server = [MMServer serverWithHost: aNetService.hostName andPort: aNetService.port];
  server.key = aNetService.name;
  
  [servers addObject: server];
  [delegate didRefresh: self];
}

- (void) netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
  NSLog(@"Could not resolve service:\n%@", errorDict);
  
  sender.delegate = nil;
  [netServices removeObject: sender];
}


@end
