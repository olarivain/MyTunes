//
//  ContentRepository.m
//  MediaManagement
//
//  Created by Kra on 3/9/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMContentRepository.h"


@implementation MMContentRepository

@synthesize kind;

- (void) loadServer: (MMServer*) server
{
  [self loadServer:server withKind: kind];
}

- (void) loadServer: (MMServer*) server withKind: (MMContentKind) kind
{
  NSLog(@"loadContentWithKind not implemented.");
}

@end
