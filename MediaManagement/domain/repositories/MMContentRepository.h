//
//  ContentRepository.h
//  MediaManagement
//
//  Created by Kra on 3/9/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaManagement/MMContent.h>

@class MMServer;

/*
 Dead code...
 */
@interface MMContentRepository : NSObject {
  MMContentKind kind;
}

@property (nonatomic, readwrite, assign) MMContentKind kind;

- (void) loadServer: (MMServer*) server;
- (void) loadServer: (MMServer*) server withKind: (MMContentKind) kind;

@end
