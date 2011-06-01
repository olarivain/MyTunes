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

- (id) initWithNetService: (NSNetService*) netService;

@property (nonatomic, readonly, retain) NSNetService *netService;
@property (readonly) int port;
@property (readonly) NSString *host;
@property (readonly) NSString *name;

@property (readonly) MMRemoteLibrary *library;


- (void) didResolve;
- (NSString*) serverURL;
- (void) stop;

@end
