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
  [super dealloc];
}


#pragma  mark - Server management;
- (MMServer*) server
{
  return server;
}

- (void) setServer:(MMServer *)newServer
{
  if(newServer == server)
  {
    return;
  }
  
  [newServer retain];
  [server release];
  server = newServer;
  
  [label setText: [server name]]; 
}


@end
