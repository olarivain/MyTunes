//
//  ServerIcon.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMServerView.h"

#import "MMServer.h"

@interface MMServerView()
@property (nonatomic, readwrite, strong) UILabel *label;
@end

@implementation MMServerView


@synthesize server;
@synthesize label;


#pragma  mark - Server management;

- (void) update
{
  [label setText: server.name]; 
}

@end
