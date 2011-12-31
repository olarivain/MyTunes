//
//  MMEncoderResourceCell.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 Edmunds. All rights reserved.
//

#import <MediaManagement/MMTitleList.h>

#import "MMEncoderResourceCell.h"

@implementation MMEncoderResourceCell

- (void) updateWithTitleList: (MMTitleList *) titleList
{
  name.text = titleList.name;
}

@end
