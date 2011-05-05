//
//  MMQueryScheduler.m
//  MediaManagement
//
//  Created by Kra on 5/4/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMQueryScheduler.h"

static MMQueryScheduler *sharedInstance;

@implementation MMQueryScheduler

+ (MMQueryScheduler*) sharedInstance
{
  @synchronized(self)
  {
    if( sharedInstance == nil)
    {
      sharedInstance = [[MMQueryScheduler alloc] init];
    }
    return  sharedInstance;
  }
}

- (id)init
{
    self = [super init];
    if (self) 
    {
      operationQueue = [[NSOperationQueue alloc] init];
      [operationQueue setMaxConcurrentOperationCount: 5];
    }
    
    return self;
}

- (void)dealloc
{
  [operationQueue release];
  [super dealloc];
}

- (void) scheduleBlock: ( void (^)(void)) block
{
  [operationQueue addOperationWithBlock: block];
}

@end
