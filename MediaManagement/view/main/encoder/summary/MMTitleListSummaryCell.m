//
//  MMEncoderResourceCell.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 kra. All rights reserved.
//

#import <MediaManagement/MMTitleList.h>

#import "MMTitleListSummaryCell.h"

@implementation MMTitleListSummaryCell

- (void) updateWithTitleList: (MMTitleList *) titleList
{
  name.text = titleList.name;
}

@end
