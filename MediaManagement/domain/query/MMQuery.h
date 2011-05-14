//
//  ContentQuery.h
//  MediaManagement
//
//  Created by Kra on 3/9/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMServer;
@class MMPlaylist;

@interface MMQuery : NSObject 
{ 
  NSString *name;
  NSString *path;
  MMServer *server;
  // this should be a collection...
  MMPlaylist *library;
}

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *path;
@property (nonatomic, readwrite, assign) MMServer *server;
@property (nonatomic, readwrite, retain) MMPlaylist *library;

+(id) queryWithName: (NSString *) name andPath: (NSString*) path;

-(id) initWithName: (NSString *) name andPath: (NSString*) path;

- (void) asyncFetchWithBlock: (void(^)(NSObject *dto)) callback;

@end
