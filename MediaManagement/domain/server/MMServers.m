//
//  Servers.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMServers.h"
#import "MMServer.h"

@interface MMServers(private)

@property (nonatomic, readwrite, retain) NSNetServiceBrowser *netServiceBrowser;
@property (nonatomic, readwrite, retain) NSMutableArray *servers;
@property (nonatomic, readwrite, retain) NSMutableArray *pendingServers;
@property (nonatomic, readwrite, assign) id<MMServersDelegate> delegate;

- (MMServer*) pendingServerWithNetService: (NSNetService*) netService;
- (MMServer*) serverWithNetService: (NSNetService*) netService;
- (MMServer*) serverWithNetService: (NSNetService*) netService inCollection: (NSArray*) serverList;
@end

@implementation MMServers

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
  self.netServiceBrowser = nil;
  
  self.pendingServers = nil;
  self.delegate = nil;
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

- (MMServer*) pendingServerWithNetService: (NSNetService*) netService
{
  return [self serverWithNetService:netService inCollection:pendingServers];
}

- (MMServer*) serverWithNetService: (NSNetService*) netService
{
  return [self serverWithNetService:netService inCollection:servers];  
}


- (MMServer*) serverWithNetService: (NSNetService*) netService inCollection: (NSArray*) serverList
{
  for(MMServer *server in serverList)
  {
    if([[server.netService name] isEqualToString: [netService name]])
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

  MMServer *server = [MMServer serverWithNetService: aNetService];
  [pendingServers addObject: server];
  
  [aNetService setDelegate: self];
  [aNetService resolveWithTimeout:5];
}

- (void) netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
  NSLog(@"Service removed.");
  
  MMServer *server = [self serverWithNetService: aNetService];
  [servers removeObject: server];
  [[self delegate] didRefresh:self];
}

- (void) netServiceBrowserWillSearch:(NSNetServiceBrowser *)aNetServiceBrowser
{
  if([[delegate class] respondsToSelector: @selector(willRefresh:)])
  {
    [delegate willRefresh:self];
  }

}

#pragma mark - NSNetService delegate methods
- (void) netServiceDidResolveAddress:(NSNetService *)sender
{
  NSLog(@"Did resolve service.");

  MMServer *server = [self pendingServerWithNetService: sender];
  [servers addObject: server];
  [pendingServers removeObject: server];
  
  [server didResolve];
  [delegate didRefresh: self];
}

- (void) netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
  NSLog(@"Did not resolve service.");
  
  MMServer *server = [self pendingServerWithNetService: sender];
  [pendingServers removeObject: server];
  [delegate didRefresh: self];
    [sender setDelegate: nil];
}


@end
