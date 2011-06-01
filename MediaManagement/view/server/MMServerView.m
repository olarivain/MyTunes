//
//  ServerIcon.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMServerView.h"

#import "MMServer.h"

@implementation MMServerView

- (id) initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
      // Initialization code
  }
  return self;
}


- (void)dealloc
{
  self.server = nil;
  [super dealloc];
}

@synthesize server;


#pragma  mark - Server management;
//- (MMServer*) server
//{
//  return server;
//}
//
//- (void) setServer:(MMServer *)newServer
//{
////  NSLog(@"Setting server: %@ %@", newServer, newServer.netService);
////  [newServer retain];
////  [server release];
//  server = newServer;
//  
//  [label setText: [newServer name]]; 
//}

- (void) update
{
  [label setText: server.name]; 
}

@end
