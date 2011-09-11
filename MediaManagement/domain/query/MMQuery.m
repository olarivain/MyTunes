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

- (MMRequestQueueItem*) request 
{
  return [self requestWithData: nil];
}
          
- (MMRequestQueueItem*) requestWithCallback: (MMQueryCallback) callback 
{
  return [self requestWithParams: nil andCallback: callback];
}

- (MMRequestQueueItem*) requestWithData: (NSData*) data
{
  // put in callback block here
  return  [requestDelegate requestWithPath: path andCallback: nil];

}

- (MMRequestQueueItem*) requestWithData: (NSData*) data andCallback: (MMQueryCallback) callback
{
  RequestCallback requestCallback = ^(MMRequestQueueItem *item){
    if(!callback) {
      return;
    }

    NSObject *dto = [item jsonObject];
    callback(dto);
  };
  
  return [requestDelegate requestWithPath: path data: data andCallback: requestCallback]; 
}

- (MMRequestQueueItem*) requestWithParams: (NSDictionary*) params
{
  return [self requestWithParams: params andCallback: nil];
}

- (MMRequestQueueItem*) requestWithParams: (NSDictionary*) params andCallback: (MMQueryCallback) callback
{
  RequestCallback requestCallback = ^(MMRequestQueueItem *item) {
    if(!callback) {
      return;
    }
    
    NSObject *dto = [item jsonObject];
    callback(dto);
  };
  
  return [requestDelegate requestWithPath: path params: params andCallback: requestCallback];
}

- (MMRequestQueueItem*) updateRequestWithParams: (NSDictionary*) params andCallback: (MMQueryCallback) callback
{
  RequestCallback requestCallback = ^(MMRequestQueueItem *item) {
    if(!callback) {
      return;
    }
    
    NSObject *dto = [item jsonObject];
    callback(dto);
  };
  
  return [requestDelegate requestWithPath: path params: params method: @"POST" andCallback: requestCallback];
}

@end
