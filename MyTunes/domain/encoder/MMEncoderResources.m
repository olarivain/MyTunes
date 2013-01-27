//
//  MMEncoderResources.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/26/13.
//
//
#import <MediaManagement/MMTitleList.h>

#import "MMEncoderResources.h"

@interface MMEncoderResources () {
    __strong NSMutableArray *_allResources;
}

@end

@implementation MMEncoderResources

+ (MMEncoderResources *) encoderResources {
    return [[MMEncoderResources alloc] init];
}

- (id) init {
    self = [super init];
    if(self) {
        _allResources = [NSMutableArray arrayWithCapacity: 50];
    }
    return self;
}

#pragma mark - Synthetic getter
- (NSArray *) scheduledResources {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(MMTitleList *evaluatedObject, NSDictionary *bindings) {
        return evaluatedObject.selectedCount > 0;
    }];
    return [_allResources filteredArrayUsingPredicate: predicate];
}

#pragma mark - Title management
- (void) addTitleLists: (NSArray *) list {
    for(MMTitleList *titleList in list) {
        [self addTitleList: titleList];
    }
}
- (void) addTitleList:(MMTitleList *)titleList {
    if ([_allResources containsObject: titleList]) {
        return;
    }
    
    [_allResources addObjectNilSafe: titleList];
}

@end
