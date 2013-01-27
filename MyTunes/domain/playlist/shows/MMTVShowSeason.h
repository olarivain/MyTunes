//
//  MMTVShowSeason.h
//  MediaManagement
//
//  Created by Olivier Larivain on 1/21/13.
//  Copyright (c) 2013 kra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMTVShow;
@class MMContent;

@interface MMTVShowSeason : NSObject

+ (MMTVShowSeason *) tvShowSeason: (MMTVShow *) show season: (NSInteger) season;

@property (nonatomic, weak, readonly) MMTVShow *show;
@property (nonatomic, assign, readonly) NSInteger season;
@property (nonatomic, readonly) NSArray *episodes;
@property (nonatomic, readonly) BOOL isUnwatched;

@property (nonatomic, readonly) NSString *humanReadableName;
@property (nonatomic, readonly) BOOL isUnplayed;

- (BOOL) addEpisode: (MMContent *) content;
- (BOOL) removeEpisode: (MMContent *) content;
- (void) sortContent;

- (void) changeUnplayedState;

@end
