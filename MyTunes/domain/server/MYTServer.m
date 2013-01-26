//
//  iServer.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//


#import <KraCommons/KCBlocks.h>
#import <KraCommons/KCHTTPClient.h>
#import <MediaManagement/MMLibrary.h>

#import <MediaManagement/MMContent.h>

#import "MYTServer.h"

#import "MMRemoteEncoder.h"


@interface MYTServer()
@property (nonatomic, readwrite) int port;
@property (nonatomic, readwrite) NSString *host;
@property (nonatomic, readwrite) NSString *name;

@property (nonatomic, readwrite) KCHTTPClient *httpClient;
@end

@implementation MYTServer

+ (MYTServer *) serverWithHost: (NSString *) host andPort: (NSInteger) port
{
	return [[MYTServer alloc] initWithHost: host andPort: port];
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
        self.httpClient.parameterEncoding = AFJSONParameterEncoding;
	}
	return self;
}
@end
