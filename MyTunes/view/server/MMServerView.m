//
//  ServerIcon.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MMServerView.h"

#import "MMServer.h"

@interface MMServerView()
@end

@implementation MMServerView


@synthesize server;


- (void) awakeFromNib
{
  self.layer.cornerRadius = 20;
}

#pragma  mark - Server management;
- (void) update
{
  [label setText: server.name]; 
}

@end
