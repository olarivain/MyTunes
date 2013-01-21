//
//  MYTServerStoreDelegate.h
//  MyTunes
//
//  Created by Olivier Larivain on 1/20/13.
//
//

#import <Foundation/Foundation.h>

@class MYTServer;

@protocol MYTServerStoreDelegate <NSObject>

@optional
- (void) didAddServer: (MYTServer *) server;
- (void) didRemoveServer: (MYTServer *) server;
- (void) didUpdateServer: (MYTServer *) server;

@end
