//
//  MYTServerStore.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/20/13.
//
//

#import <KraCommons/KCHTTPClient.h>

#import "MYTServerStore.h"

#import "MYTServerStoreDelegate.h"
#import "MMServer.h"
#import "MMRemoteLibrary.h"

#import "MMContentAssembler+Client.h"

static MYTServerStore *sharedInstance;

@interface MYTServerStore ()<NSNetServiceBrowserDelegate, NSNetServiceDelegate>
@property (nonatomic, readonly) id<MYTServerStoreDelegate> currentDelegate;

@property (nonatomic, readwrite) NSNetServiceBrowser *netServiceBrowser;
@property (nonatomic, readwrite) NSMutableArray *netServices;

@property (nonatomic, readwrite) NSMutableDictionary *serversByName;
@property (nonatomic, copy) NSMutableArray *servers;
@property (nonatomic, readwrite, strong) MMServer *currentServer;

@property (nonatomic, assign) dispatch_queue_t serversQueue;
@end

@implementation MYTServerStore

+ (MYTServerStore *) sharedInstance {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[MYTServerStore alloc] init];
	});
	
	return sharedInstance;
}

- (id) init {
	self = [super init];
	if(self) {
		self.netServiceBrowser = [[NSNetServiceBrowser alloc] init];
		self.netServiceBrowser.delegate = self;
		self.netServices = [NSMutableArray arrayWithCapacity:5];
		
		_servers = [NSMutableArray arrayWithCapacity: 5];
		self.serversByName = [NSMutableDictionary dictionaryWithCapacity: 5];
		self.serversQueue = dispatch_queue_create("com.kra.server.synchronization", DISPATCH_QUEUE_SERIAL);
	}
	return self;
}


#pragma mark - Synthetic getters
- (NSArray *) servers {
	__block NSArray *theServers = nil;
	dispatch_sync(self.serversQueue, ^{
		theServers = [_servers copy];
	});
	return theServers;
}

- (id<MYTServerStoreDelegate>) currentDelegate {
	UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
	
	if ([rootController conformsToProtocol: @protocol(MYTServerStoreDelegate)]) {
		return (id<MYTServerStoreDelegate>) rootController;
	}
	
	if(![rootController isKindOfClass: UINavigationController.class]) {
		return nil;
	}
	
	UIViewController *topController = [(UINavigationController *) rootController topViewController];
	if([topController conformsToProtocol: @protocol(MYTServerStoreDelegate)]) {
		return (id<MYTServerStoreDelegate>) topController;
	}
	
	return nil;
}

#pragma mark - selecting a server
- (void) selectServer: (MMServer *) server
			 callback: (KCErrorBlock) callback {
	if(![self.servers containsObject: server]) {
		NSString *errorMessage = [NSString stringWithFormat: @"Server %@ could not be found", server.name];
		NSError *error = [NSError errorWithCode: -1 andMessage: errorMessage];
		DispatchMainThread(callback, error);
		return;
	}
	
	[server.httpClient getPath: @"/library"
					parameters: nil
					   success:^(AFHTTPRequestOperation *operation, id responseObject) {
						   [self didSelectServer: server
											 dto: responseObject
										callback: callback];
						   
					   }
					   failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
						   self.currentServer = nil;
						   DispatchMainThread(callback, error);
					   }];
}

- (void) didSelectServer: (MMServer *) server
					 dto: (id) dto
				callback: (KCErrorBlock) callback
{
	// sanity check
	if(![dto isKindOfClass: [NSArray class]]) {
		NSLog(@"FATAL: unexpected content fetched from load library request");
	}
	
	NSArray *playlistDtos = (NSArray*) dto;
	
	// now assemble playlists and add them to self.
	MMContentAssembler *assembler = [MMContentAssembler sharedInstance];
	[assembler updateLibrary: server.library withDto: playlistDtos];
	self.currentServer = server;
	
	DispatchMainThread(callback, nil);
}

#pragma mark - starting the server search
- (void) startSearching {
	// for now, start the search and never end it. We'll see the battery impact later.
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		// schedule on the main thread to avoid concurrency issues, for now
		[self.netServiceBrowser scheduleInRunLoop: [NSRunLoop mainRunLoop]
										  forMode: NSDefaultRunLoopMode];
		[self.netServiceBrowser searchForServicesOfType:@"_http._tcp" inDomain:@"local."];
	});
}

#pragma mark - NetService Browser delegate
- (void) netServiceBrowser: (NSNetServiceBrowser *)aNetServiceBrowser
			didFindService: (NSNetService *)aNetService
				moreComing: (BOOL)moreComing
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

- (void) netServiceBrowser: (NSNetServiceBrowser *)aNetServiceBrowser
		  didRemoveService: (NSNetService *)aNetService
				moreComing: (BOOL)moreComing
{
	DDLogInfo(@"Service %@ removed.", aNetService.name);
	
	// get a hold on the server. remove it and notify delegate
	MMServer *server = [self serverNamed: aNetService.name];
	[self removeServerNamed: aNetService.name];
	[self.netServices removeObject: aNetService];
	
	// and notify whatever view controller is on screen
	id<MYTServerStoreDelegate> delegate = self.currentDelegate;
	if([delegate respondsToSelector: @selector(didRemoveServer:)]) {
		[delegate didRemoveServer: server];
	}
}

#pragma mark - NetService delegate
- (void) netServiceDidResolveAddress:(NSNetService *)aNetService
{
	DDLogInfo(@"Resolved service %@:\nhttp://%@:%i", aNetService.name, aNetService.hostName, aNetService.port);
	MMServer *server = [MMServer serverWithHost:aNetService.hostName
										andPort: aNetService.port];
	
	[self addServer: server withName: aNetService.name];
	
	// and notify whatever view controller is on screen
	id<MYTServerStoreDelegate> delegate = self.currentDelegate;
	if([delegate respondsToSelector: @selector(didAddServer:)]) {
		[delegate didAddServer: server];
	}
}

- (void) netService:(NSNetService *)aNetService
	  didNotResolve:(NSDictionary *)errorDict
{
	DDLogInfo(@"Could not resolve service:\n%@", errorDict);
}

#pragma mark - Synchronizing access to servers
- (void) addServer: (MMServer *) server withName: (NSString *) name{
	dispatch_sync(self.serversQueue, ^{
		[_servers addObjectNilSafe: server];
		[self.serversByName setObjectNilSafe: server forKey: name];
	});
}

- (MMServer *) serverNamed: (NSString *) name{
	__block MMServer *server = nil;
	dispatch_sync(self.serversQueue, ^{
		server = [self.serversByName objectForKey: name];
	});
	return server;
}

- (void) removeServerNamed: (NSString *) name{
	dispatch_sync(self.serversQueue, ^{
		MMServer *server = [self.serversByName objectForKey: name];
		[_servers removeObject: server];
		
		[self.serversByName removeObjectForKey: name];
	});
}

@end
