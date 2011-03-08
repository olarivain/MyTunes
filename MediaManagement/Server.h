//
//  iServer.h
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Server : NSObject {
  @private  
  NSNetService *netService;
}

- (id) initWithNetService: (NSNetService*) netService;

@property (readonly) NSNetService *netService;
@property (readonly) NSString *hostname;
@property (readonly) int port;
@property (readonly) NSString *name;

- (void) resolve;

@end
