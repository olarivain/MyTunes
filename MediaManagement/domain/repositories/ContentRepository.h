//
//  ContentRepository.h
//  MediaManagement
//
//  Created by Kra on 3/9/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Content.h"

@class Server;

@interface ContentRepository : NSObject {
  ContentKind kind;
}

@property (nonatomic, readwrite, assign) ContentKind kind;

- (void) loadServer: (Server*) server;
- (void) loadServer: (Server*) server withKind: (ContentKind) kind;

@end
