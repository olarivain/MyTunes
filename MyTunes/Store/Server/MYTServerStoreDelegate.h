//
//  MYTServerStoreDelegate.h
//  MyTunes
//
//  Created by Olivier Larivain on 1/20/13.
//
//

#import <Foundation/Foundation.h>

@class MMServer;

@protocol MYTServerStoreDelegate <NSObject>

@optional
- (void) didAddServer: (MMServer *) server;
- (void) didRemoveServer: (MMServer *) server;
- (void) didUpdateServer: (MMServer *) server;

@end
