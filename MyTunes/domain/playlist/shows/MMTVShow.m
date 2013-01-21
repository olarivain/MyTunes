//
//  MMTVShow.m
//  MediaManagement
//
//  Created by Olivier Larivain on 1/21/13.
//  Copyright (c) 2013 kra. All rights reserved.
//

#import "MMTVShow.h"

#import "MMTVShowSeason.h"
#import "MMContent.h"

@interface MMTVShow () {
    __strong NSMutableArray *_seasons;
}
@property (nonatomic, strong, readwrite) NSString *name;

@end

@implementation MMTVShow

+ (MMTVShow *) tvShowWithName: (NSString *) name {
    return [[MMTVShow alloc] initWithName: name];
}

- (id) initWithName: (NSString *) name {
    self = [super init];
    if(self) {
        self.name = name;
        _seasons = [NSMutableArray arrayWithCapacity: 15];
    }
    
    return self;
}

#pragma mark - Content Group protocol
- (BOOL) addContent:(MMContent *)content {
    MMTVShowSeason *season = [self seasonForContent: content];
    return [season addEpisode: content];
}

- (BOOL) removeContent:(MMContent *)content {
    MMTVShowSeason *season = [self seasonForContent: content];
    return [season removeEpisode: content];
}

- (void) sortContent {
    [_seasons sortUsingComparator:^NSComparisonResult(MMTVShowSeason *obj1, MMTVShowSeason *obj2) {
        NSInteger diff = obj1.season - obj2.season;
        
        return diff < 0 ? NSOrderedAscending : diff == 0 ? NSOrderedSame : NSOrderedDescending;
    }];
}

#pragma mark - convenience accessor
- (MMTVShowSeason *) seasonForContent: (MMContent *) content {
    NSInteger seasonNumber = [content.season integerValue];
    for(MMTVShowSeason *season in _seasons) {
        if(season.season == seasonNumber) {
            return season;
        }
    }
    
    return [MMTVShowSeason tvShowSeason: self season: seasonNumber];
}

@end
