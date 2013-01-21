//
//  MYTLibraryStore.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/21/13.
//
//

#import <MediaManagement/MMLibrary.h>
#import <MediaManagement/MMPlaylist.h>

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

#pragma mark - Loading playlist listing
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
                           self.currentLibrary = nil;
                           self.currentPlaylist = nil;
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
        NSError *error = [NSError errorWithCode: -42 andMessage: @"An error occured"];
        self.currentLibrary = nil;
        self.currentPlaylist = nil;
        DispatchMainThread(callback, error);
        return;
	}
	
	NSArray *playlistDtos = (NSArray*) dto;
	
	// now assemble playlists and add them to self.
	MMContentAssembler *assembler = [MMContentAssembler sharedInstance];
	self.currentLibrary = [assembler createLibrary: playlistDtos];
    self.currentLibrary.name = server.name;
    self.currentPlaylist = [self.currentLibrary.playlists boundSafeObjectAtIndex: 0];
	
	DispatchMainThread(callback, nil);
}

#pragma mark - Loading a playlist
- (void) loadPlaylist: (KCErrorBlock) callback {
    MYTServer *server = [MYTServerStore sharedInstance].currentServer;
    
    __strong MMPlaylist *playlist = self.currentPlaylist;
    [server.httpClient getPath: [NSString stringWithFormat:@"/library/%@", playlist.uniqueId]
					parameters: nil
					   success:^(AFHTTPRequestOperation *operation, id responseObject) {
						   [self didLoadPlaylist: playlist
											 dto: responseObject
										callback: callback];
						   
					   }
					   failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
                           self.currentPlaylist = nil;
						   DispatchMainThread(callback, error);
					   }];
}
- (void) didLoadPlaylist: (MMPlaylist *) playlist
                     dto: (NSDictionary *) dto
                callback: (KCErrorBlock) callback {
    // sanity check
	if(![dto isKindOfClass: [NSDictionary class]]) {
		DDLogWarn(@"FATAL: unexpected content fetched from load library request");
        NSError *error = [NSError errorWithCode: -42 andMessage: @"An error occured"];
        self.currentLibrary = nil;
        self.currentPlaylist = nil;
        DispatchMainThread(callback, error);
        return;
	}
    
    NSDictionary *contentDto = (NSDictionary*) dto;
	// now assemble playlists and add them to self.
	MMContentAssembler *assembler = [MMContentAssembler sharedInstance];
    [assembler updatePlaylist: playlist
                      withDto: contentDto];
    DispatchMainThread(callback, nil);
}

@end
