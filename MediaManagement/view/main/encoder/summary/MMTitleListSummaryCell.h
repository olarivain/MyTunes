//
//  MMEncoderResourceCell.h
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMTitleList;

@interface MMTitleListSummaryCell : UITableViewCell
{
  IBOutlet __strong UILabel *name;
}

- (void) updateWithTitleList: (MMTitleList *) titleList;

@end
