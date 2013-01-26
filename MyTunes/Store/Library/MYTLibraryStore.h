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
@class MMContent;

@interface MYTLibraryStore : NSObject

@property (nonatomic, strong, readonly) MMLibrary *currentLibrary;
@property (nonatomic, strong, readwrite) MMPlaylist *currentPlaylist;

+ (MYTLibraryStore *) sharedInstance;
- (void) loadCurrentLibraryListing: (KCErrorBlock) callback;
- (void) loadPlaylist: (KCErrorBlock) callback;

- (void) saveContentList: (NSMutableSet *) content
                callback: (KCErrorBlock) callback;
@end
