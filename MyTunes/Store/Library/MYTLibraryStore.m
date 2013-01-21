//
//  MYTLibraryStore.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/21/13.
//
//

#import <MediaManagement/MMLibrary.h>

#import <KraCommons/KCHTTPClient.h>

#import "MYTLibraryStore.h"

#import "MYTServerStore.h"

#import "MYTServer.h"
#import "MMContentAssembler+Client.h"

static MYTLibraryStore *sharedInstance;

@interface MYTLibraryStore ()
@property (nonatomic, strong, readwrite) MMLibrary *currentLibrary;
@end

@implementation MYTLibraryStore

+ (MYTLibraryStore *) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MYTLibraryStore alloc] init];
    });
    return sharedInstance;
}

- (void) loadCurrentLibraryListing:(KCErrorBlock)callback {
	
    MYTServer *server = [MYTServerStore sharedInstance].currentServer;
    
	[server.httpClient getPath: @"/library"
					parameters: nil
					   success:^(AFHTTPRequestOperation *operation, id responseObject) {
						   [self didSelectServer: server
											 dto: responseObject
										callback: callback];
						   
					   }
					   failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
						   DispatchMainThread(callback, error);
					   }];
}

- (void) didSelectServer: (MYTServer *) server
					 dto: (id) dto
				callback: (KCErrorBlock) callback
{
	// sanity check
	if(![dto isKindOfClass: [NSArray class]]) {
		DDLogWarn(@"FATAL: unexpected content fetched from load library request");
	}
	
	NSArray *playlistDtos = (NSArray*) dto;
	
	// now assemble playlists and add them to self.
	MMContentAssembler *assembler = [MMContentAssembler sharedInstance];
	self.currentLibrary = [assembler createLibrary: playlistDtos];
    self.currentLibrary.name = server.name;
	
	DispatchMainThread(callback, nil);
}

@end
