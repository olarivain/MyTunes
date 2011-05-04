//
//  ContentRepository.h
//  MediaManagement
//
//  Created by Kra on 3/9/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaManagement/MMContent.h>

@class Server;

@interface ContentRepository : NSObject {
  MMContentKind kind;
}

@property (nonatomic, readwrite, assign) MMContentKind kind;

- (void) loadServer: (Server*) server;
- (void) loadServer: (Server*) server withKind: (MMContentKind) kind;

@end
