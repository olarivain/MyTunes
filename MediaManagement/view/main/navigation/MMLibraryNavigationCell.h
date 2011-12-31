//
//  MMLibraryNavigationCell.h
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 Edmunds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMLibraryNavigationCell : UITableViewCell
{
  IBOutlet __strong UILabel *nameLabel;
}

- (void) setName: (NSString *) name;

@end
