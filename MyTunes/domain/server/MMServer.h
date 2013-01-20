//
//  iServer.h
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KCRequestDelegate;

@class MMRemoteLibrary;
@class MMRemoteEncoder;

typedef void(^MMServerCallback)(id dto);

@interface MMServer : NSObject {
  int port;
  __weak id key;
  __strong NSString *host;
  __strong NSString *name;
  
  __strong MMRemoteLibrary *library;
  
  __strong MMRemoteEncoder *encoder;
  
  __strong KCRequestDelegate *requestDelegate;
}

+ (MMServer *) serverWithHost: (NSString *) host andPort: (NSInteger) port;

@property (nonatomic, readwrite, weak) id key;
@property (nonatomic, readonly) int port;
@property (nonatomic, readonly) NSString *host;
@property (nonatomic, readonly) NSString *name;

@property (nonatomic, readonly) MMRemoteLibrary *library;
@property (nonatomic, readonly) MMRemoteEncoder *encoder;

- (BOOL) hasSystemPlaylist;

// default, GET request
- (void) requestWithPath: (NSString *) path andCallback: (MMServerCallback) callback;
// GET request with params
- (void) requestWithPath: (NSString *) path params: (NSDictionary *) params andCallback:(MMServerCallback)callback;
// POST request
- (void) updateRequestWithPath: (NSString *) path params: (NSDictionary *) params andCallback: (MMServerCallback) callback;
// raw request
- (void) requestWithPath: (NSString *) path params: (NSDictionary *) params method: (NSString *) method andCallback:(MMServerCallback)callback;

// delete request
// POST request
- (void) deleteRequestWithPath: (NSString *) path params: (NSDictionary *) params andCallback: (MMServerCallback) callback;

@end
