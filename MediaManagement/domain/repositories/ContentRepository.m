//
//  ContentRepository.m
//  MediaManagement
//
//  Created by Kra on 3/9/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "ContentRepository.h"


@implementation ContentRepository

@synthesize kind;

- (void) loadServer: (Server*) server
{
  [self loadServer:server withKind: kind];
}

- (void) loadServer: (Server*) server withKind: (MMContentKind) kind
{
  NSLog(@"loadContentWithKind not implemented.");
}

@end
