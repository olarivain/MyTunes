//
//  iServer.h
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaManagement/MMContent.h>

@class MMQueryGroup;

@interface MMServer : NSObject {
  @private  
  NSNetService *netService;
  
  int port;
  NSString *host;
  NSString *name;
  
  NSMutableArray *queryGroups;
  
  NSDate *lastUpdate;
}

- (id) initWithNetService: (NSNetService*) netService;

@property (readonly) NSNetService *netService;
@property (readonly) int port;
@property (readonly) NSString *host;
@property (readonly) NSString *name;

@property (readonly) NSArray *queryGroups;


- (void) didResolve;

- (NSString*) serverURL;
@end
