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

@property (nonatomic, readwrite, retain) NSString *name;
@property (nonatomic, readwrite, retain) NSString *path;
@property (nonatomic, readwrite, retain) MMRequestDelegate *requestDelegate;
@end

@implementation MMQuery

+(id) queryWithName: (NSString *) name andPath: (NSString*) path
{
  return [[[MMQuery alloc] initWithName:name andPath:path] autorelease];
}

-(id) initWithName: (NSString *) queryName andPath: (NSString*) queryPath
{
  self = [super init];
  if(self)
  {
    self.name = queryName;
    self.path = queryPath;
  }
  
  return self;
}

- (void) dealloc
{
  self.name = nil;
  self.path = nil;
  self.requestDelegate = nil;
  [super dealloc];
}

@synthesize name;
@synthesize path;
@synthesize server;
@synthesize library;
@synthesize requestDelegate;

- (void) setServer:(MMServer *)newServer
{
  if(newServer == server)
  {
    return;
  }
  
  [newServer retain];
  [server release];
  server = newServer;
  self.requestDelegate = [MMRequestDelegate delegateWithServer: server];
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
