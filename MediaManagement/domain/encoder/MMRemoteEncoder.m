//
//  MMEncoder.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/30/11.
//  Copyright (c) 2011 Edmunds. All rights reserved.
//

#import <KraCommons/KCBlocks.h>
#import <MediaManagement/MMTitleAssembler.h>

#import "MMRemoteEncoder.h"

#import "MMServer.h"

@interface MMRemoteEncoder()
- (id) initWithServer: (MMServer *) server;
- (void) didLoadAvailableResources: (NSArray *) dto;
@end

@implementation MMRemoteEncoder

+ (MMRemoteEncoder *) encoderWithServer: (MMServer *) server
{
  return [[MMRemoteEncoder alloc] initWithServer: server];
}

- (id) initWithServer: (MMServer *) aServer
{
  self = [super init];
  if(self)
  {
    server = aServer;
  }
  return self;
}

@synthesize availableResources;
@synthesize pendingList;

- (void) loadAvailableResources: (MMRemoteEncoderCallback) callback
{
  MMServerCallback serverCallback = ^(NSArray *dto){
    [self didLoadAvailableResources: dto];
    DispatchMainThread(callback);
  };
  
  [server requestWithPath:@"/encoder" andCallback: serverCallback];
}

- (void) didLoadAvailableResources: (NSArray *) dto
{
  MMTitleAssembler *assembler = [MMTitleAssembler sharedInstance];
  availableResources = [assembler createTitleLists: dto];
}

@end
