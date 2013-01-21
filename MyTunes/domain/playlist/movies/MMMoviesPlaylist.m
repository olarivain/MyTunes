//
//  MMMoviesMediaLibrary.m
//  MediaManagementCommon
//
//  Created by Kra on 5/1/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMMoviesPlaylist.h"


@implementation MMMoviesPlaylist

- (id)initWithContentKind:(MMContentKind)kind andSize:(NSUInteger)size
{
    self = [super initWithContentKind:kind andSize: size];
    if (self)
    {
        if(kind != MOVIE)
        {
            DDLogError(@"FATAL: Movie Library Must have a type of MOVIE");
        }
    }
    
    return self;
}

#pragma mark - synthetic getters
- (NSArray *) unwatchedMovies {
	NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(MMContent *evaluatedObject, NSDictionary *bindings) {
		return evaluatedObject.unplayed;
	}];
	return [self.content filteredArrayUsingPredicate: predicate];
}

- (void) privateSortContent: (NSMutableArray *) groups {
    
}


@end
