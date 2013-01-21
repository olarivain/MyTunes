//
//  MMTVShowPlaylist.m
//  MediaManagementCommon
//
//  Created by Kra on 5/31/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMTVShowPlaylist.h"

#import "MMTVShow.h"

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

- (id<MMContentGroup>) contentGroupForContent: (MMContent *) content
{
    if(content.name == nil) {
        return self.unknownShow;
    }
    
    for(MMTVShow *show in self.contentGroups) {
        
        if([show.name caseInsensitiveCompare: content.name] == NSOrderedSame) {
            return show;
        }
    }
    
    return [MMTVShow tvShowWithName: content.name];
}

@end
