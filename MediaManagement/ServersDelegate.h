//
//  ServersDelegate.h
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Servers;

@protocol ServersDelegate <NSObject>

- (void) willRefresh: (Servers*) sender;
- (void) didRefresh: (Servers*) sender;

@end
