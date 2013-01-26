//
//  MMTVShowPlaylist.m
//  MediaManagementCommon
//
//  Created by Kra on 5/31/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMTVShowPlaylist.h"

#import "MMTVShow.h"
#import "MMTVShowSeason.h"

@interface MMTVShowPlaylist() {
}
@property (nonatomic, strong, readwrite) MMTVShow *unknownShow;
@end

@implementation MMTVShowPlaylist


- (id)initWithContentKind:(MMContentKind)kind andSize:(NSUInteger)size
{
    self = [super initWithContentKind:kind andSize: size];
    if (self)
    {
        if(kind != TV_SHOW)
        {
            DDLogError(@"FATAL: TV Show Playlist must have a kind of TV_SHOW");
        }
        _unknownShow = [MMTVShow tvShowWithName: nil];
        [self addContentGroup: _unknownShow];
    }
    return self;
}

#pragma mark - add/remove overrides
- (void) removeContent: (MMContent*) content {
    [super removeContent: content];
    
    // remove the episode from the show
    MMTVShow *show = [self contentGroupForContent: content];
    [show removeContent: content];
    
    // remove the show altogether if it has no more episodes
    if(show.totalEpisodeCount == 0) {
        [self removeContentGroup: show];
    }
}

- (void) updateContent: (MMContent *) content {
    MMTVShow *previousShow = [self contentGroupForContent: content];
    
    [super updateContent: content];
    
    // remove the show altogether if it has no more episodes
    if(previousShow.totalEpisodeCount == 0) {
        [self removeContentGroup: previousShow];
    }
}

#pragma mark - accessing all sorted TV Show seasons
- (NSArray *) sortedSeasons {
	NSMutableArray *sortedSeasons = [NSMutableArray arrayWithCapacity: self.contentGroups.count * 10];

	for(MMTVShow *show in self.contentGroups) {
		[sortedSeasons addObjectsFromArray: show.seasons];
	}
	
	return sortedSeasons;
}

- (NSArray *) sortedUnwatchedSeasons {
    NSArray *sortedSeason = self.sortedSeasons;
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(MMTVShowSeason *evaluatedObject, NSDictionary *bindings) {
        return evaluatedObject.isUnwatched;
    }];
    return [sortedSeason filteredArrayUsingPredicate: predicate];
}

#pragma mark - sorting
- (void) privateSortContent: (NSMutableArray *) groups {
    [groups sortUsingComparator:^NSComparisonResult(MMTVShow *obj1, MMTVShow *obj2) {
        if(obj1.name == nil) {
            return NSOrderedDescending;
        }
        
        if(obj2.name == nil) {
            return NSOrderedAscending;
        }
        
        return [obj1.name caseInsensitiveCompare: obj2.name];
    }];
    
    for(MMTVShow *show in groups) {
        [show sortContent];
    }
}

#pragma mark - private overrides
- (id<MMContentGroup>) contentGroupForContent: (MMContent *) content
{
    if(content.name == nil) {
        return self.unknownShow;
    }
    
    // try by show name first
    for(MMTVShow *show in self.contentGroups) {
        if([show.name caseInsensitiveCompare: content.show] == NSOrderedSame) {
            return show;
        }
    }
    
    // try by id now
    for(MMTVShow *show in self.contentGroups) {
        for(MMTVShowSeason *season in show.seasons) {
            if([season.episodes containsObject: content]) {
                return show;
            }
        }
    }
    
    MMTVShow *show = [MMTVShow tvShowWithName: content.show];
    [self addContentGroup: show];
    return show;
}

@end
