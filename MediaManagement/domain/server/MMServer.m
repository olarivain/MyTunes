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
- (id) initWithHost: (NSString *) host andPort: (NSInteger) port;
@end

@implementation MMServer

+ (MMServer *) serverWithHost: (NSString *) host andPort: (NSInteger) port
{
  return [[MMServer alloc] initWithHost: host andPort: port];
}

- (id) initWithHost:(NSString *)aHost andPort:(NSInteger)aPort
{
  self = [super init];
  if(self)
  {
    port = aPort;
    host = aHost;
    name = [[host componentsSeparatedByString:@".local"] objectAtIndex:0];
    requestDelegate = [KCRequestDelegate requestDelegateWithHost: host andPort: port];
    
    library = [MMRemoteLibrary libraryWithServer: self];
    encoder = [MMRemoteEncoder encoderWithServer: self];
  }
  return self;
}


@synthesize key;
@synthesize name;
@synthesize port;
@synthesize host;
@synthesize library;
@synthesize encoder;

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

- (void) updateRequestWithPath: (NSString *) path params: (NSDictionary *) params andCallback: (MMServerCallback) callback
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
#if DEBUG_NETWORK == 1
    NSLog(@"Request %@: %@", item.success ? @"succeeded" : @"failed", item.url.absoluteString);
    if(!item.success)
    {
      NSLog(@"HTTP Code for failure: %i", item.status);
    }
#endif
    callback(item.jsonObject);
  };
  [requestDelegate requestWithPath: path params: params method: method andCallback: networkCallback];
}

@end
