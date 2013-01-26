//
//  MMTVShowSeason.m
//  MediaManagement
//
//  Created by Olivier Larivain on 1/21/13.
//  Copyright (c) 2013 kra. All rights reserved.
//

#import <MediaManagement/MMContent.h>

#import "MMTVShowSeason.h"

#import "MMTVShow.h"

@interface MMTVShowSeason () {
    __strong NSMutableArray *_episodes;
}
@property (nonatomic, weak, readwrite) MMTVShow *show;
@property (nonatomic, assign, readwrite) NSInteger season;
@end

@implementation MMTVShowSeason

+ (MMTVShowSeason *) tvShowSeason: (MMTVShow *) show season: (NSInteger) season {
    return [[MMTVShowSeason alloc] initWithShow: show season: season];
}

- (id) initWithShow: (MMTVShow *) show season: (NSInteger) season {
    self = [super init];
    if(self) {
        self.show = show;
        self.season = season;
        
        _episodes = [NSMutableArray arrayWithCapacity: 30];
    }
    
    return self;
}

#pragma mark - synthetic getters
- (NSString *) humanReadableName {
    NSString *humanReadableShow = self.show.name == nil ? @"Unknown Show" : self.show.name;
    NSString *humanReadableSeason = self.season == 0 ? @"Unknown Season" : [NSString stringWithFormat: @"Season %i", self.season];
    return [NSString stringWithFormat: @"%@ - %@", humanReadableShow, humanReadableSeason];
}

- (BOOL) isUnwatched {
    for(MMContent *content in self.episodes) {
        if(content.unplayed) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - managing episodes
- (BOOL) addEpisode: (MMContent *) content {
    NSAssert(content.kind == TV_SHOW, @"Only tv shows can be added to a TV Show season");
    if([self.episodes containsObject: content]) {
        return NO;
    }
    
    [_episodes addObjectNilSafe: content];
    return YES;
}

- (BOOL) removeEpisode: (MMContent *) content {
    if(![self.episodes containsObject: content]) {
        return NO;
    }
    
    [_episodes removeObject: content];
    return YES;
}

#pragma mark - sorting
- (void) sortContent {
    [_episodes sortUsingComparator:^NSComparisonResult(MMContent *obj1, MMContent *obj2) {
        if(obj1.episodeNumber == nil && obj2.episodeNumber == nil) {
            return [obj1.name caseInsensitiveCompare: obj2.name];
        }
        
        if(obj1.episodeNumber == nil) {
            return NSOrderedDescending;
        }
        if (obj2.episodeNumber == nil) {
            return NSOrderedAscending;
        }
        
        return [obj1.episodeNumber compare: obj2.episodeNumber];
    }];
}

@end
