//
//  MMAudioTrackView.h
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMAudioTrack;
@class MMAudioTrackListView;

@interface MMAudioTrackCell : UITableViewCell
{
  IBOutlet __strong UILabel *trackLabel;
  IBOutlet __strong UIImageView *checkmarkView;
  IBOutlet __strong UIView *separator;
}

- (void) updateWithAudioTrack: (MMAudioTrack *) track;
- (void) hidesSeparator: (BOOL) hide;

@end
