//
//  iServer.h
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MMRemoteLibrary;
@class KCRequestDelegate;

typedef void(^MMServerCallback)(id dto);

@interface MMServer : NSObject {
  @private  
  __strong NSNetService *netService;
  
  int port;
  __strong NSString *host;
  __strong NSString *name;
  
  __strong MMRemoteLibrary *library;
  
  __strong NSDate *lastUpdate;
  
  __strong KCRequestDelegate *requestDelegate;
}

+ (MMServer *) serverWithNetService: (NSNetService*) netService;

- (id) initWithNetService: (NSNetService*) netService;

@property (nonatomic, readonly) NSNetService *netService;
@property (nonatomic, readonly) int port;
@property (nonatomic, readonly) NSString *host;
@property (nonatomic, readonly) NSString *name;

@property (nonatomic, readonly, strong) MMRemoteLibrary *library;


- (void) didResolve;

- (BOOL) hasSystemPlaylist;

// default, GET request
- (void) requestWithPath: (NSString *) path andCallback: (MMServerCallback) callback;
// GET request with params
- (void) requestWithPath: (NSString *) path params: (NSDictionary *) params andCallback:(MMServerCallback)callback;
// POST request
- (void) udpateRequestWithPath: (NSString *) path params: (NSDictionary *) params andCallback: (MMServerCallback) callback;
// raw request
- (void) requestWithPath: (NSString *) path params: (NSDictionary *) params method: (NSString *) method andCallback:(MMServerCallback)callback;


@end
