//
//  MMQueryScheduler.h
//  MediaManagement
//
//  Created by Kra on 5/4/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MMQueryScheduler : NSObject {
@private
  NSOperationQueue *operationQueue;
}

+ (MMQueryScheduler*) sharedInstance;

- (void) scheduleBlock: ( void (^)(void)) block;

@end
