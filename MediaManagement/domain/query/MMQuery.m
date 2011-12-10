//
//  ContentQuery.m
//  MediaManagement
//
//  Created by Kra on 3/9/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMQuery.h"
#import "MMServer.h"

#import "MMRequestQueueItem.h"
#import "MMRequestDelegate.h"

@interface MMQuery()

@end

@implementation MMQuery

+(id) queryWithName: (NSString *) name andPath: (NSString*) path
{
  return [[MMQuery alloc] initWithName:name andPath:path];
}

-(id) initWithName: (NSString *) queryName andPath: (NSString*) queryPath
{
  self = [super init];
  if(self)
  {
    name = queryName;
    path = queryPath;
  }
  
  return self;
}


@synthesize name;
@synthesize path;
@synthesize server;
@synthesize library;

- (void) setServer:(MMServer *)newServer
{
  if(newServer == server)
  {
    return;
  }
  
  server = newServer;
  requestDelegate = [MMRequestDelegate delegateWithServer: server];
}

#pragma mark - Read requests
- (MMRequestQueueItem*) request 
{
  return [self requestWithParams: nil];
}
 
- (MMRequestQueueItem*) requestWithParams: (NSDictionary*) params
{
  return [self requestWithParams: params andCallback: nil];
}

- (MMRequestQueueItem*) requestWithCallback: (MMQueryCallback) callback 
{
  return [self requestWithParams: nil andCallback: callback];
}

- (MMRequestQueueItem*) requestWithParams: (NSDictionary*) params andCallback: (MMQueryCallback) callback
{
  RequestCallback requestCallback = ^(MMRequestQueueItem *item) 
  {
    if(!callback) 
    {
      return;
    }
    
    NSObject *dto = [item jsonObject];
    callback(dto);
  };
  
  return [requestDelegate requestWithPath: path params: params andCallback: requestCallback];
}

#pragma mark - Update requests
- (MMRequestQueueItem*) updateRequestWithParams: (NSDictionary*) params 
{
  return [self updateRequestWithParams: params andCallback: nil];
}

- (MMRequestQueueItem*) updateRequestWithParams: (NSDictionary*) params andCallback: (MMQueryCallback) callback
{
  RequestCallback requestCallback = ^(MMRequestQueueItem *item) 
  {
    if(!callback) 
    {
      return;
    }
    
    NSObject *dto = [item jsonObject];
    callback(dto);
  };
  
  return [requestDelegate requestWithPath: path params: params method: @"POST" andCallback: requestCallback];
}

@end
