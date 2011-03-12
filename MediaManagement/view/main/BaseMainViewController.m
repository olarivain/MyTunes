//
//  BaseMainViewController.m
//  MediaManagement
//
//  Created by Kra on 3/9/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "BaseMainViewController.h"

#import "Server.h"

@implementation BaseMainViewController

- (void) dealloc
{
  [server release];
  [repository release];
  [self dealloc];
}

@synthesize server;
@synthesize repository;

@end
