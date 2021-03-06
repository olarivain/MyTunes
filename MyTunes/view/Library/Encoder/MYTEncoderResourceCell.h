//
//  MYTEncoderResourceCell.h
//  MyTunes
//
//  Created by Olivier Larivain on 1/26/13.
//
//

#import <UIKit/UIKit.h>

@class MMTitleList;

@interface MYTEncoderResourceCell : UITableViewCell

- (void) updateWithTitleList: (MMTitleList *) titleList
                  showingAll: (BOOL) showingAll;
- (CGFloat) idealHeightForTitleList: (MMTitleList *) titleList;

@end
