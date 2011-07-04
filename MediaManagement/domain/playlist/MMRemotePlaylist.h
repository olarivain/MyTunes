//
//  MMRemotePlaylist.h
//  MediaManagement
//
//  Created by Kra on 5/14/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaManagement/MMPlaylist.h>

@class MMContent;

/*
 Remote playlist represents a playlist sitting in the remote iTunes instance.
 A remote playlist can either be loaded or one of its MMContent can be updated (one item at a time)
 */

@interface MMPlaylist(MMPlaylist_Remote)
- (void) loadWithBlock: (void(^)(void)) callback;
- (void) updateContent: (MMContent*) content withBlock: (void(^)(void)) callback;
@end
