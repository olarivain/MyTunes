//
//  iServer.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//


#import <KraCommons/KCBlocks.h>
#import <KraCommons/KCRequestDelegate.h>
#import <KraCommons/KCRequestQueueItem.h>

#import <MediaManagement/MMContent.h>

#import "MMServer.h"

#import "MMRemoteEncoder.h"
#import "MMRemoteLibrary.h"

@interface MMServer()
@end

@implementation MMServer
+ (MMServer *) serverWithNetService: (NSNetService*) netService
{
  return [[MMServer alloc] initWithNetService: netService];
}

- (id) initWithNetService: (NSNetService*) service
{
  self = [super init];
  if(self)
  {
    netService = service;
    library = [MMRemoteLibrary libraryWithServer: self];
    encoder = [MMRemoteEncoder encoderWithServer: self];
  }
  return self;
}


@synthesize name;
@synthesize port;
@synthesize host;
@synthesize library;
@synthesize netService;
@synthesize encoder;

#pragma mark - Bonjour resolution
- (void) didResolve
{
  port = netService.port;
  
  host = netService.hostName;
  name = [[host componentsSeparatedByString:@".local"] objectAtIndex:0];
  
  requestDelegate = [KCRequestDelegate requestDelegateWithHost: host andPort: port];

}

#pragma mark - Playlist convenience
- (BOOL) hasSystemPlaylist
{
  return [library.systemPlaylists count] > 0;
}

#pragma mark - network calls
- (void) requestWithPath: (NSString *) path andCallback: (MMServerCallback) callback
{
  [self requestWithPath: path params: nil method: @"GET" andCallback: callback];
}

- (void) requestWithPath: (NSString *) path params: (NSDictionary *) params andCallback:(MMServerCallback)callback
{
  [self requestWithPath: path params: params method: @"GET" andCallback: callback];
}

- (void) udpateRequestWithPath: (NSString *) path params: (NSDictionary *) params andCallback: (MMServerCallback) callback
{
  [self requestWithPath: path params: params method: @"POST" andCallback: callback];
}

- (void) requestWithPath: (NSString *) path params: (NSDictionary *) params method: (NSString *) method andCallback:(MMServerCallback) callback
{
  if(callback == nil)
  {
    NSLog(@"FATAL, callback is required for server calls.");
    return;
  }
  
  KCRequestCallback networkCallback = ^(KCRequestQueueItem *item){
    callback(item.jsonObject);
  };
  [requestDelegate requestWithPath: path params: params method: method andCallback: networkCallback];
}

@end
