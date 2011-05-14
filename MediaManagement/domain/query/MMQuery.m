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
#import "MMQueryGroup.h"
#import "MMServer.h"
#import "MMQueryScheduler.h"
#import "NSHTTPURLResponse+MediaManagement.h"
#import "JSONKit.h"


@implementation MMQuery

+(id) queryWithName: (NSString *) name andPath: (NSString*) path
{
  return [MMQuery queryWithName: name path: path andGroup:nil];
}

+(id) queryWithName: (NSString *) name path: (NSString*) path andGroup: (MMQueryGroup*) group
{
  return [[[MMQuery alloc] initWithName:name path:path andGroup:group] autorelease];
}

-(id) initWithName: (NSString *) queryName andPath: (NSString*) queryPath
{
  [self initWithName:name path:path andGroup: nil];
  return self;
}

-(id) initWithName: (NSString *) queryName path: (NSString*) queryPath andGroup: (MMQueryGroup*) queryGroup
{
  self = [super init];
  if(self)
  {
    name = [queryName retain];
    path = [queryPath retain];
    [queryGroup addQuery: self];
  }
  
  return self;
}

- (void) dealloc
{
  [name release];
  [path release];
  self.group = nil;
  [super dealloc];
}

@synthesize name;
@synthesize path;
@synthesize group;
@synthesize server;
@synthesize library;

- (void) reloadWithBlock: (void(^)(void)) callback
{
  void(^refresh)(void)  = ^{
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
    NSDictionary *dto = [decoder objectWithData: body];
    MMPlaylist *newLibrary = [[MMContentAssembler sharedInstance] createLibrary: dto];
    self.library = newLibrary;

    dispatch_queue_t main = dispatch_get_main_queue();
    dispatch_async(main, callback);
  };
  
  MMQueryScheduler *scheduler = [MMQueryScheduler sharedInstance];
  [scheduler scheduleBlock:refresh];
}

@end
