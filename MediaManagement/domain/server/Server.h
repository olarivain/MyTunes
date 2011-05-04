//
//  iServer.h
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaManagement/MMContent.h>

@interface Server : NSObject {
  @private  
  NSNetService *netService;
  
  int port;
  NSString *host;
  NSString *name;
  
  NSMutableArray *songs;
  NSMutableArray *movies;
  NSMutableArray *tvShows;
  NSMutableArray *podcasts;
  NSMutableArray *itunesU;
  
  NSDate *lastUpdate;
}

- (id) initWithNetService: (NSNetService*) netService;

@property (readonly) NSNetService *netService;
@property (readonly) int port;
@property (readonly) NSString *host;
@property (readonly) NSString *name;


@property (readonly) NSMutableArray *songs;
@property (readonly) NSMutableArray *movies;
@property (readonly) NSMutableArray *tvShows;
@property (readonly) NSMutableArray *podcasts;
@property (readonly) NSMutableArray *itunesU;


- (void) didResolve;

- (void) loadContent: (MMContentKind) kind;

@end
