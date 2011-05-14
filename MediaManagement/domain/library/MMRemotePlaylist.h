//
//  MMRemotePlaylist.h
//  MediaManagement
//
//  Created by Kra on 5/14/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMPlaylist.h"

@class MMServer;
@class MMQuery;

@interface MMRemotePlaylist : MMPlaylist {
@private
  MMServer *server;
  MMQuery *query;
}

@end
