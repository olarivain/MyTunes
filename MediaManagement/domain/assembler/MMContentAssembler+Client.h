//
//  MMContentAssembler+Client.h
//  MediaManagement
//
//  Created by Kra on 5/15/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaManagement/MMContentAssembler.h>

@class MMPlaylist;


@interface MMContentAssembler (MMContentAssembler_Client)

- (void) updateLibrary: (MMLibrary*) library withDto: (NSArray*) dto;
- (void) updatePlaylist: (MMPlaylist*) playlist withDto: (NSDictionary*) dto;
@end
