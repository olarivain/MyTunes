//
//  MMEncoderResourceCell.h
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 Edmunds. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMTitleList;

@interface MMEncoderResourceCell : UITableViewCell
{
  IBOutlet __strong UILabel *name;
}

- (void) updateWithTitleList: (MMTitleList *) titleList;

@end
