//
//  ServerIcon.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "ServerView.h"

#import "Server.h"

@implementation ServerView

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
- (Server*) server
{
  return server;
}

- (void) setServer:(Server *)newServer
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
