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
@interface MYTLibraryStore : NSObject

@property (nonatomic, strong, readonly) MMLibrary *currentLibrary;

+ (MYTLibraryStore *) sharedInstance;
- (void) loadCurrentLibraryListing: (KCErrorBlock) callback;

@end
