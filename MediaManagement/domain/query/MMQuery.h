//
//  ContentQuery.h
//  MediaManagement
//
//  Created by Kra on 3/9/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMRequestQueueItem.h"

typedef void(^MMQueryCallback)(NSObject*);

@class MMServer;
@class MMPlaylist;
@class MMRequestDelegate;

/*
 A query represents a iTunes resource on the server. It maps to a library list, playlist, track and such and can be used for read or write operations.
 Queries a statically instantiated by their owning domain objects.
 A query is a high level abstraction of the REST, as such it can be requested, with or without data (in which case the request will be a post), with
 or without params (in which case the query will be a GET. It is async in nature, hence the callback param.
 */
@interface MMQuery : NSObject 
{ 
  NSString *name;
  NSString *path;
  MMServer *__weak server;
  // this should be a collection...
  MMPlaylist *__weak library;
    
  MMRequestDelegate *requestDelegate;
}

@property (nonatomic, readonly, strong) NSString *name;
@property (nonatomic, readonly, strong) NSString *path;
@property (nonatomic, readwrite, weak) MMServer *server;
@property (nonatomic, readwrite, weak) MMPlaylist *library;

+(id) queryWithName: (NSString *) name andPath: (NSString*) path;
-(id) initWithName: (NSString *) name andPath: (NSString*) path;

- (MMRequestQueueItem*) request;
- (MMRequestQueueItem*) requestWithCallback: (MMQueryCallback) callback;

- (MMRequestQueueItem*) requestWithParams: (NSDictionary*) params;
- (MMRequestQueueItem*) requestWithParams: (NSDictionary*) params andCallback: (MMQueryCallback) callback;

- (MMRequestQueueItem*) updateRequestWithParams: (NSDictionary*) params;
- (MMRequestQueueItem*) updateRequestWithParams: (NSDictionary*) params andCallback: (MMQueryCallback) callback;
@end
