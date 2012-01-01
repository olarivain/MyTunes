//
//  MMEncoder.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/30/11.
//  Copyright (c) 2011 Edmunds. All rights reserved.
//

#import <KraCommons/KCBlocks.h>
#import <MediaManagement/MMTitleAssembler.h>
#import <MediaManagement/MMTitleList.h>

#import "MMRemoteEncoder.h"

#import "MMServer.h"

@interface MMRemoteEncoder()
- (id) initWithServer: (MMServer *) server;
- (void) didLoadAvailableResources: (NSArray *) dto;
- (void) didScanResource: (MMTitleList *) titleList withDto:(NSDictionary *)dto;
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

#pragma mark - Listing available resources
- (void) loadAvailableResources: (MMRemoteEncoderCallback) callback
{
  // always load this content, since it's highly variable
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


#pragma mark - Scanning a specific resource
- (void) scanResource: (MMTitleList *) titleList andCallback: (MMRemoteEncoderCallback) callback
{
  // update only content that belongs to us
  if(![availableResources containsObject: titleList])
  {
    return;
  }
  
  // don't reload if we already have the content
  if([titleList.titles count] > 0)
  {
    DispatchMainThread(callback);
    return;
  }
  
  MMServerCallback serverCallback = ^(NSDictionary *dto){
    // local callback 
    [self didScanResource: titleList withDto: dto];
    
    // and then proceed to UI callback, on main thread
    DispatchMainThread(callback);
  };
  
  // go out to server for content
  NSString *resourcePath = [NSString stringWithFormat: @"/encoder/%@", titleList.encodedTitleListId];
  [server requestWithPath: resourcePath andCallback: serverCallback];
}

- (void) didScanResource: (MMTitleList *) titleList withDto:(NSDictionary *)dto 
{
  MMTitleAssembler *assembler = [MMTitleAssembler sharedInstance];
  [assembler updateTitleList: titleList withDto: dto];
}

@end
