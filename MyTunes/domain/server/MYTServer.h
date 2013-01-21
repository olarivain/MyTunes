//
//  iServer.h
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KCHTTPClient;
@class KCRequestDelegate;

@class MMLibrary;
@class MMRemoteEncoder;

typedef void(^MMServerCallback)(id dto);

@interface MYTServer : NSObject {
}

+ (MYTServer *) serverWithHost: (NSString *) host andPort: (NSInteger) port;

@property (nonatomic, readwrite, weak) id key;
@property (nonatomic, readonly) int port;
@property (nonatomic, readonly) NSString *host;
@property (nonatomic, readonly) NSString *name;

@property (nonatomic, readonly) MMLibrary *library;
@property (nonatomic, readonly) MMRemoteEncoder *encoder;

@property (nonatomic, readonly) KCHTTPClient *httpClient;

@end
