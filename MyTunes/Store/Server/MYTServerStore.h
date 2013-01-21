//
//  MYTServerStore.h
//  MyTunes
//
//  Created by Olivier Larivain on 1/20/13.
//
//

#import <Foundation/Foundation.h>

@class MMServer;

@interface MYTServerStore : NSObject {
	__strong NSMutableArray *_servers;
}

@property (nonatomic, readonly, copy) NSArray *servers;
@property (nonatomic, readonly, strong) MMServer *currentServer;

+ (MYTServerStore *) sharedInstance;

- (void) startSearching;

- (void) selectServer: (MMServer *) server callback: (KCErrorBlock) callback;

@end
