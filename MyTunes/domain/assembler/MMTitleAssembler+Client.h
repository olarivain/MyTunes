//
//  MMTitleAssembler+Client.h
//  MediaManagement
//
//  Created by Olivier Larivain on 3/10/12.
//  Copyright (c) 2012 kra. All rights reserved.
//

#import <MediaManagement/MMTitleAssembler.h>

@interface MMTitleAssembler (Client)

- (NSArray *) createTitleLists: (NSArray *) dtos;
- (void) updateTitleList: (MMTitleList *) titleList withDto: (NSDictionary *) dto;

@end
