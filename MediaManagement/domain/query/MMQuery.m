//
//  ContentQuery.m
//  MediaManagement
//
//  Created by Kra on 3/9/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <MediaManagement/MMPlaylist.h>
#import <MediaManagement/MMContentAssembler.h>
#import "MMQuery.h"
#import "MMServer.h"
#import "MMQueryScheduler.h"
#import "NSHTTPURLResponse+MediaManagement.h"
#import "JSONKit.h"


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

- (NSObject*) performRequest
{
  NSString *stringURL = [NSString stringWithFormat: @"%@%@", [server serverURL], path];
  NSURL *url = [NSURL URLWithString: stringURL];
  
  NSURLRequest *request = [NSURLRequest requestWithURL: url];
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
  
  JSONDecoder *decoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionStrict];
  NSObject *dto = [decoder objectWithData: body];
  return dto;

}

- (void) refresh: (void(^)(NSObject *dto)) callback
{
  NSObject *dto = [self performRequest];

  if(callback != nil)
  {
    callback(dto);
  }

}

- (NSObject*) fetch
{
  return [self performRequest];
}

- (void) asyncFetchWithBlock: (void(^)(NSObject *dto)) callback
{
  void(^refresh)(void)  = ^{
    [self refresh: callback];
  };
  
  MMQueryScheduler *scheduler = [MMQueryScheduler sharedInstance];
  [scheduler scheduleBlock:refresh];
}

@end
