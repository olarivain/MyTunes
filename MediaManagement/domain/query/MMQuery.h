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
  MMServer *server;
  // this should be a collection...
  MMPlaylist *library;
    
  MMRequestDelegate *requestDelegate;
}

@property (nonatomic, readonly, retain) NSString *name;
@property (nonatomic, readonly, retain) NSString *path;
@property (nonatomic, readwrite, assign) MMServer *server;
@property (nonatomic, readwrite, retain) MMPlaylist *library;

+(id) queryWithName: (NSString *) name andPath: (NSString*) path;
-(id) initWithName: (NSString *) name andPath: (NSString*) path;

- (MMRequestQueueItem*) request;
- (MMRequestQueueItem*) requestWithCallback: (MMQueryCallback) callback;

- (MMRequestQueueItem*) requestWithData: (NSData*) data;
- (MMRequestQueueItem*) requestWithData: (NSData*) data andCallback: (MMQueryCallback) callback;

- (MMRequestQueueItem*) requestWithParams: (NSDictionary*) params;
- (MMRequestQueueItem*) requestWithParams: (NSDictionary*) params andCallback: (MMQueryCallback) callback;

- (MMRequestQueueItem*) updateRequestWithParams: (NSDictionary*) params andCallback: (MMQueryCallback) callback;
@end
