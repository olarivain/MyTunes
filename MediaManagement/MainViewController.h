//
//  MainViewController.h
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Server;

@protocol MainViewController <NSObject>

- (void) setServer: (Server*) server;

@end
