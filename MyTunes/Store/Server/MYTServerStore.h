//
//  MYTServerStore.h
//  MyTunes
//
//  Created by Olivier Larivain on 1/20/13.
//
//

#import <Foundation/Foundation.h>

@class MYTServer;

@interface MYTServerStore : NSObject {
	__strong NSMutableArray *_servers;
}

@property (nonatomic, readonly, copy) NSArray *servers;
@property (nonatomic, readwrite, strong) MYTServer *currentServer;

+ (MYTServerStore *) sharedInstance;

- (void) startSearching;

@end
