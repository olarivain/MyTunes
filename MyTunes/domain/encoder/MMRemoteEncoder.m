//
//  MMEncoder.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/30/11.
//  Copyright (c) 2011 kra. All rights reserved.
//

#import <KraCommons/KCBlocks.h>
#import <KraCommons/KCHTTPClient.h>
#import <MediaManagement/MMTitleList.h>

#import "MMTitleAssembler+Client.h"
#import "MMRemoteEncoder.h"

#import "MYTServer.h"

@interface MMRemoteEncoder()
@property (nonatomic, readwrite, weak) MYTServer *server;
@property (nonatomic, readwrite) NSArray *availableResources;
@property (nonatomic, readwrite) MMPendingList *pendingList;
@end

@implementation MMRemoteEncoder

+ (MMRemoteEncoder *) encoderWithServer: (MYTServer *) server
{
	return [[MMRemoteEncoder alloc] initWithServer: server];
}

- (id) initWithServer: (MYTServer *) aServer
{
	self = [super init];
	if(self)
	{
		self.server = aServer;
	}
	return self;
}

#pragma mark - Listing available resources
- (void) loadAvailableResources: (MMRemoteEncoderCallback) callback
{
	// always load this content, since it's highly variable
	[self.server.httpClient getPath: @"/encoder"
						 parameters: nil
							success:^(AFHTTPRequestOperation *operation, id responseObject) {
								[self didLoadAvailableResources: responseObject callback: callback];
							}
							failure: nil];
}

- (void) didLoadAvailableResources: (NSArray *) dto
						  callback: (MMRemoteEncoderCallback) callback
{
	MMTitleAssembler *assembler = [MMTitleAssembler sharedInstance];
	self.availableResources = [assembler createTitleLists: dto];
	DispatchMainThread(callback);
}


#pragma mark - Scanning a specific resource
- (void) scanResource: (MMTitleList *) titleList andCallback: (MMRemoteEncoderCallback) callback
{
	
	// update only content that belongs to us
	if(![self.availableResources containsObject: titleList])
	{
		return;
	}
	
	// go out to server for content
	NSString *resourcePath = [NSString stringWithFormat: @"/encoder/%@", titleList.encodedTitleListId];
	
	[self.server.httpClient getPath: resourcePath
						 parameters: nil
							success:^(AFHTTPRequestOperation *operation, id responseObject) {
								[self didScanResource: titleList withDto: responseObject callback: callback];
							}
							failure: nil];
}

- (void) didScanResource: (MMTitleList *) titleList withDto:(NSDictionary *)dto callback: (MMRemoteEncoderCallback) callback
{
	MMTitleAssembler *assembler = [MMTitleAssembler sharedInstance];
	[assembler updateTitleList: titleList withDto: dto];
	DispatchMainThread(callback);
}

#pragma mark - Scheduling a title for encoding
- (void) scheduleTitleList: (MMTitleList *) titleList withCallback: (MMRemoteEncoderCallback) callback
{
	// make sure we have something here...
	if(titleList == nil)
	{
		DispatchMainThread(callback);
		return;
	}
	
	NSString *path = [NSString stringWithFormat:@"/encoder/%@", titleList.encodedTitleListId];
	
	MMTitleAssembler *assembler = [MMTitleAssembler sharedInstance];
	NSDictionary *dto = [assembler writeTitleList: titleList];
	
	[self.server.httpClient postPath: path
						  parameters: dto
							 success: ^(AFHTTPRequestOperation *operation, id responseObject) {
								 [self didScheduleTitleList: titleList withDto: responseObject callback: callback];
							 }
							 failure: nil];
}

- (void) didScheduleTitleList: (MMTitleList *) titleList withDto: (NSDictionary *) dto callback: (MMRemoteEncoderCallback) callback
{
	DDLogInfo(@"did schedule");
	DispatchMainThread(callback);
}

#pragma mark - delete a title list
- (void) deleteTitleList: (MMTitleList *) titleList withCallback: (MMRemoteEncoderErrorCallback) callback
{
	// make sure we have something here...
	if(titleList == nil)
	{
		DispatchMainThread(callback, nil);
		return;
	}
	
	
#warning AFNetworking SHOULD take care of the error, double check
	NSString *path = [NSString stringWithFormat:@"/encoder/%@", titleList.encodedTitleListId];
	[self.server.httpClient deletePath: path
							parameters: nil
							   success:^(AFHTTPRequestOperation *operation, id responseObject) {
								   // extract error and dispatch main thread
								   NSError *error = nil;
								   if([responseObject count] > 0) {
									   error = [NSError errorWithDomain: @"ITS"
																   code: 0
															   userInfo: responseObject];
								   }
								   
								   DispatchMainThread(callback, error);
							   }
							   failure: nil];
}


@end
