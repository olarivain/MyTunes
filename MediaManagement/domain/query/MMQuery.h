//
//  ContentQuery.h
//  MediaManagement
//
//  Created by Kra on 3/9/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMQueryGroup;
@class MMServer;

@interface MMQuery : NSObject 
{ 
  NSString *name;
  NSString *path;
  MMQueryGroup *group;
  MMServer *server;
}

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *path;
@property (nonatomic, readwrite, retain) MMQueryGroup *group;
@property (nonatomic, readwrite, assign) MMServer *server;

+(id) queryWithName: (NSString *) name andPath: (NSString*) path;
+(id) queryWithName: (NSString *) name path: (NSString*) path andGroup: (MMQueryGroup*) group;

-(id) initWithName: (NSString *) name andPath: (NSString*) path;
-(id) initWithName: (NSString *) name path: (NSString*) path andGroup: (MMQueryGroup*) group;

- (void) reloadWithBlock: (void(^)(void)) callback;

@end
