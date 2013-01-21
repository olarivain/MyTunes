//
//  iServer.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//


#import <KraCommons/KCBlocks.h>
#import <KraCommons/KCHTTPClient.h>

#import <MediaManagement/MMContent.h>

#import "MMServer.h"

#import "MMRemoteEncoder.h"
#import "MMRemoteLibrary.h"


@interface MMServer()
@property (nonatomic, readwrite) int port;
@property (nonatomic, readwrite) NSString *host;
@property (nonatomic, readwrite) NSString *name;

@property (nonatomic, readwrite) MMRemoteLibrary *library;
@property (nonatomic, readwrite) MMRemoteEncoder *encoder;
@property (nonatomic, readwrite) KCHTTPClient *httpClient;
@end

@implementation MMServer

+ (MMServer *) serverWithHost: (NSString *) host andPort: (NSInteger) port
{
	return [[MMServer alloc] initWithHost: host andPort: port];
}

- (id) initWithHost:(NSString *)aHost andPort:(NSInteger)aPort
{
	self = [super init];
	if(self)
	{
		self.port = aPort;
		self.host = aHost;
		self.name = [[self.host componentsSeparatedByString:@".local"] objectAtIndex:0];
		
		
		NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"http://%@:%i", self.host, self.port]];
		self.httpClient = [[KCHTTPClient alloc] initWithBaseURL: url];
		//    requestDelegate = [KCRequestDelegate requestDelegateWithHost: host andPort: port];
		
		self.library = [MMRemoteLibrary libraryWithServer: self];
		self.encoder = [MMRemoteEncoder encoderWithServer: self];
	}
	return self;
}

#pragma mark - Playlist convenience
- (BOOL) hasSystemPlaylist
{
	return [self.library.systemPlaylists count] > 0;
}

@end
