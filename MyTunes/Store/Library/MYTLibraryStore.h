//
//  MYTLibraryStore.h
//  MyTunes
//
//  Created by Olivier Larivain on 1/21/13.
//
//

#import <Foundation/Foundation.h>

@class MYTServer;
@class MMLibrary;
@class MMPlaylist;

@interface MYTLibraryStore : NSObject

@property (nonatomic, strong, readonly) MMLibrary *currentLibrary;
@property (nonatomic, strong, readwrite) MMPlaylist *currentPlaylist;

+ (MYTLibraryStore *) sharedInstance;
- (void) loadCurrentLibraryListing: (KCErrorBlock) callback;
- (void) loadPlaylist: (KCErrorBlock) callback;

@end
