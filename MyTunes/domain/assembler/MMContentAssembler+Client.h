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
@class MMLibrary;


@interface MMContentAssembler (MMContentAssembler_Client)

- (MMLibrary *) createLibrary: (NSArray*) dto;
- (void) updatePlaylist: (MMPlaylist*) playlist withDto: (NSDictionary*) dto;
@end
