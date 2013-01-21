//
//  MMRemotePlaylist.m
//  MediaManagement
//
//  Created by Kra on 5/14/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <KraCommons/KCBlocks.h>
#import <KraCommons/KCHTTPClient.h>
#import "MMRemotePlaylist.h"

#import "MMRemoteLibrary.h"
#import "MMContentAssembler+Client.h"

#import "MMServer.h"

@interface MMPlaylist(MMPlaylist_Remote_Private)
@property (nonatomic, readonly) MMServer *server;
@end

@implementation MMPlaylist(MMPlaylist_Remote)

#pragma mark - Synthetic Getter
- (MMServer *) server
{
	return ((MMRemoteLibrary *) library).server;
}

#pragma mark - Reading playlist content
- (void) loadWithBlock: (MMPlaylistCallback) callback
{
	NSString *readPath = [NSString stringWithFormat:@"/library/%@", uniqueId];
	
	[self.server.httpClient getPath: readPath
						 parameters: nil
							success:^(AFHTTPRequestOperation *operation, id responseObject) {
								[self didLoad: responseObject callback: callback];
							}
							failure:nil];
}

- (void) didLoad: (NSObject*) dto callback: (MMPlaylistCallback) callback
{
	if(![dto isKindOfClass: [NSDictionary class]])
	{
		NSLog(@"FATAL: got unexpected response while reading playlist with ID %@.", uniqueId);
		return;
	}
	
	NSDictionary *dictionary = (NSDictionary*) dto;
	MMContentAssembler *assembler = [MMContentAssembler sharedInstance];
	[assembler updatePlaylist: self withDto: dictionary];
	
	DispatchMainThread(callback);
}


#pragma mark - Updating a playlist item
- (void) updateContent: (MMContent*) content withBlock: (MMPlaylistCallback) callback
{
	NSString *path = [NSString stringWithFormat:@"/library/%@/%@", uniqueId, content.contentId];
	NSDictionary *dictionary = [[MMContentAssembler sharedInstance] writeContent: content];
	
	[self.server.httpClient postPath: path
						  parameters: dictionary
							 success:^(AFHTTPRequestOperation *operation, id responseObject) {
								 DispatchMainThread(callback);
							 }
							 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
								 DispatchMainThread(callback);
							 }];
}

@end
