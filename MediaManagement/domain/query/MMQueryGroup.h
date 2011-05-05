//
//  QueryGroup.h
//  MediaManagement
//
//  Created by Kra on 5/4/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMQuery;
@class MMServer;

@interface MMQueryGroup : NSObject {
@private
  NSString *name;
  NSMutableArray *queries;
  MMServer *server;
}

@property (readonly) NSString *name;
@property (readonly) NSArray *queries;
@property (nonatomic, readwrite, assign)  MMServer *server;

+ (id) queryGroupWithName: (NSString *) name;
- (id) initWithName: (NSString *) name;

- (void) addQuery: (MMQuery*) query;
- (void) removeQuery: (MMQuery*) query;

- (NSInteger) queryCount;

@end
