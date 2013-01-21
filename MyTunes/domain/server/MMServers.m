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
@property (nonatomic, readwrite) NSArray *servers;
//@property (nonatomic, readwrite, weak) id<MMServersDelegate> delegate;
@property (nonatomic, readwrite) NSNetServiceBrowser *netServiceBrowser;
@property (nonatomic, readwrite) NSMutableArray *netServices;
@property (nonatomic, readwrite, assign) BOOL didStartSearch;
@end

@implementation MMServers

- (id) init
{
	self = [super init];
	if(self)
	{
		self.netServiceBrowser = [[NSNetServiceBrowser alloc] init];
		self.netServiceBrowser.delegate = self;
		
		self.netServices = [NSMutableArray arrayWithCapacity:5];
		
		self.servers = [NSMutableArray array];
	}
	return self;
}

- (void) dealloc
{
	[self.netServiceBrowser stop];
}

#pragma mark - Server access methods

- (void) startSearch
{
	if(self.didStartSearch)
	{
		return;
	}
	
	self.didStartSearch = YES;
	[self.netServiceBrowser searchForServicesOfType:@"_http._tcp" inDomain:@"local."];
}

- (void) stopSearch
{
	[self.netServiceBrowser stop];
	[self.netServices removeAllObjects];
}

- (MMServer *) serverWithNetService: (NSNetService *) netService
{
	for(MMServer *server in self.servers)
	{
		if([server.key isEqual: netService.name])
		{
			return server;
		}
	}
	return nil;
}

- (void) removeNetService: (NSNetService *) netService
{
	NSNetService *toRemove = nil;
	for(NSNetService *service in self.netServices)
	{
		if([service.name isEqual: netService.name])
		{
			toRemove = service;
			break;
		}
	}
	
	toRemove.delegate = nil;
	[self.netServices removeObject: toRemove];
}


#pragma mark - NSNetServiceBrowserDelegate methods
- (void) netServiceBrowserWillSearch:(NSNetServiceBrowser *)aNetServiceBrowser
{
	[self.delegate willRefresh:self];
}

- (void) netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
	if(![aNetService.name hasPrefix:@"iServe-"])
	{
		return;
	}
	
	DDLogInfo(@"Found service %@.", aNetService.name);
	
	[self.netServices addObject: aNetService];
	
	aNetService.delegate = self;
	[aNetService resolveWithTimeout:5];
}

- (void) netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
	DDLogInfo(@"Service %@ removed.", aNetService.name);
	
	// net service disappeared, first remove any server associated
	MMServer *removed = [self serverWithNetService: aNetService];
	[_servers removeObject: removed];
	
	// drop net service
	[self removeNetService: aNetService];
	
	// notify delegate
	[self.delegate didRefresh:self];
}

#pragma mark - NSNetService delegate methods
- (void) netServiceDidResolveAddress:(NSNetService *)aNetService
{
	DDLogInfo(@"Resolved service %@:\nhttp://%@:%i", aNetService.name, aNetService.hostName, aNetService.port);
	
	// this delegate method gets called more than once every once in a while, so make sure this doens't happen
	if([self serverWithNetService: aNetService] != nil)
	{
		return;
	}
	
	// service did resolve properly, build server with hostname/port, add to list and notify delegate
	MMServer *server = [MMServer serverWithHost: aNetService.hostName andPort: aNetService.port];
	server.key = aNetService.name;
	
	[_servers addObjectNilSafe: server];
	[self.delegate didRefresh: self];
}

- (void) netService:(NSNetService *)aNetService didNotResolve:(NSDictionary *)errorDict
{
	DDLogInfo(@"Could not resolve service:\n%@", errorDict);
	
	[self removeNetService: aNetService];
}


@end
