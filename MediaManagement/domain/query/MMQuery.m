//
//  ContentQuery.m
//  MediaManagement
//
//  Created by Kra on 3/9/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMQuery.h"
#import "MMServer.h"
#import "MMQueryScheduler.h"
#import "NSHTTPURLResponse+MediaManagement.h"
#import "JSONKit.h"


@interface MMQuery()
- (NSObject*) performRequestWithData: (NSData*) data;
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
    name = [queryName retain];
    path = [queryPath retain];
  }
  
  return self;
}

- (void) dealloc
{
  [name release];
  [path release];
  [super dealloc];
}

@synthesize name;
@synthesize path;
@synthesize server;
@synthesize library;

- (NSObject*) performRequestWithData: (NSData*) data
{
  NSString *stringURL = [NSString stringWithFormat: @"%@%@", [server serverURL], path];
  NSURL *url = [NSURL URLWithString: stringURL];
  
  NSURLRequest *request = nil;
  if(data != nil)
  {
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL: url];
    [mutableRequest setHTTPBody: data];
    [mutableRequest setHTTPMethod: @"POST"];
    request = mutableRequest;
  }
  else
  {
    request = [NSURLRequest requestWithURL: url];
  }
  
  NSHTTPURLResponse *response = nil;
  NSError *error = nil;
  NSData *body = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
  if(error != nil)
  {
    NSLog(@"Error happened, %@", error);
  }
  
  if(![response isValid])
  {
    NSLog(@"Received code %i from request %@.", [response statusCode], stringURL);
  }
  
  JSONDecoder *decoder = [[[JSONDecoder alloc] initWithParseOptions: JKParseOptionLooseUnicode] autorelease];
  NSObject *dto = [decoder objectWithData: body];
  return dto;

}

- (NSObject*) request: (NSData*) data
{
  return [self performRequestWithData: data];
}

- (void) request: (NSData*) data andCallback: (void(^)(NSObject *dto)) callback
{
  NSObject *dto = [self performRequestWithData: data];
  
  if(callback != nil)
  {
    callback(dto);
  }
  
}

- (void) asyncRequestWithBlock: (void(^)(NSObject *dto)) callback
{
  [self asyncRequest: nil withBlock: callback];
}

- (void) asyncRequest: (NSObject*) object withBlock:  (void(^)(NSObject *dto)) callback
{
  NSData *data = nil;
  if([object isKindOfClass: [NSDictionary class]])
  {
    data = [((NSDictionary*) object) JSONData];
  }
  else if([object isKindOfClass: [NSArray class]])
  {
    data = [((NSArray*) object) JSONData];
  }
  
  void(^updload)(void)  = ^{
    [self request: data andCallback: callback];
  };
  
  MMQueryScheduler *scheduler = [MMQueryScheduler sharedInstance];
  [scheduler scheduleBlock:updload];

}

@end
