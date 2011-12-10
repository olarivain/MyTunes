//
//  iServer.h
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaManagement/MMContent.h>

@class MMRemoteLibrary;

@interface MMServer : NSObject {
  @private  
  NSNetService *netService;
  
  int port;
  NSString *host;
  NSString *name;
  
  MMRemoteLibrary *library;
  
  NSDate *lastUpdate;
}

+ (MMServer *) serverWithNetService: (NSNetService*) netService;

- (id) initWithNetService: (NSNetService*) netService;

@property (nonatomic, readonly, strong) NSNetService *netService;
@property (nonatomic, readonly, assign) int port;
@property (nonatomic, readonly, strong) NSString *host;
@property (nonatomic, readonly, strong) NSString *name;

@property (nonatomic, readonly, strong) MMRemoteLibrary *library;


- (void) didResolve;
- (NSString*) serverURL;

- (BOOL) hasSystemPlaylist;

@end
