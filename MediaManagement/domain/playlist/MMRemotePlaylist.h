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

@interface MMPlaylist(MMPlaylist_Remote)
- (void) loadWithBlock: (void(^)(void)) callback;
- (void) updateContent: (MMContent*) content withBlock: (void(^)(void)) callback;
@end
