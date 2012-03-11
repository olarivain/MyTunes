//
//  MMTitleStatus.h
//  MediaManagement
//
//  Created by Olivier Larivain on 3/10/12.
//  Copyright (c) 2012 kra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMTitle;

@interface MMTitleStatusView : UIView
{
  IBOutlet __weak UILabel *status;
  IBOutlet __weak UILabel *progress;
  
}

- (void) updateWithTitle: (MMTitle *) title;

@end
