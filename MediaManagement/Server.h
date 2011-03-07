//
//  iServer.h
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Server : NSObject {
  @private  
  NSString *hostname;
  int port;
}

@property (readonly) NSString *hostname;
@property (readonly) int port;

- (id) initWithHostName: (NSString*) host andPort: (int) serverPort;

- (NSString *) name;
@end
