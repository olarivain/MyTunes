//
//  MYTAudioTrackCell.h
//  MyTunes
//
//  Created by Olivier Larivain on 1/27/13.
//
//

#import <UIKit/UIKit.h>

@class MMAudioTrack;
@class MMSubtitleTrack;

@interface MYTAudioSubtitleTrackCell : UITableViewCell

- (void) updateWithAudioTrack: (MMAudioTrack *) track;
- (void) updateWithSubtitleTrack: (MMSubtitleTrack *) track;

@end
