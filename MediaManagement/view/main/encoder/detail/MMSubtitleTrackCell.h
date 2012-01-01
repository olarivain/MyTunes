//
//  MMSubtitleTrackView.h
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 Edmunds. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMSubtitleTrack;

@interface MMSubtitleTrackCell : UITableViewCell
{
  IBOutlet __strong UILabel *trackLabel;
  IBOutlet __strong UIImageView *checkmarkView;
  IBOutlet __strong UIView *separator;
}

- (void) updateWithSubtitleTrack: (MMSubtitleTrack *) track;
- (void) hidesSeparator: (BOOL) hide;

@end
