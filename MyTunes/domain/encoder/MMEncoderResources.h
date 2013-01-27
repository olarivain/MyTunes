//
//  MMEncoderResources.h
//  MyTunes
//
//  Created by Olivier Larivain on 1/26/13.
//
//

#import <Foundation/Foundation.h>

@class MMTitleList;

@interface MMEncoderResources : NSObject

+ (MMEncoderResources *) encoderResources;

@property (copy, nonatomic, readonly) NSArray *allResources;
@property (copy, nonatomic, readonly) NSArray *scheduledResources;

- (void) addTitleLists: (NSArray *) list;
- (void) addTitleList: (MMTitleList *) titleList;

@end
