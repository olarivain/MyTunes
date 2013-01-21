//
//  MMTVShow.h
//  MediaManagement
//
//  Created by Olivier Larivain on 1/21/13.
//  Copyright (c) 2013 kra. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MMContentGroup.h"

@interface MMTVShow : NSObject<MMContentGroup>

+ (MMTVShow *) tvShowWithName: (NSString *) name;

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSArray *seasons;

@property (nonatomic, readonly) NSInteger totalEpisodeCount;

@end
