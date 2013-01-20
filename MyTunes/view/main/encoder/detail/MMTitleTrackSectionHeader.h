//
//  MMTitleTrackSectionHeader.h
//  MediaManagement
//
//  Created by Larivain, Olivier on 1/1/12.
//  Copyright (c) 2012 kra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMTitleTrackSectionHeader : UIView
{
  __strong UILabel *label;
}

- (void) setTitle: (NSString *) title;

@end
