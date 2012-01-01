//
//  MMAudioTrackTableController.h
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 Edmunds. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMAudioTrackCell;
@class MMSubtitleTrackCell;

@class MMAudioTrack;
@class MMSubtitleTrack;

@class MMTitle;

@protocol MMTitleTrackTableDelegate <NSObject>

- (void) title: (MMTitle *) title didSelectAudioTrack:(MMAudioTrack *)track;
- (void) title: (MMTitle *) title didSelectSubtitleTrack: (MMSubtitleTrack *) track;

@end

@interface MMTitleTrackTableController : NSObject<UITableViewDelegate, UITableViewDataSource>
{
  IBOutlet __strong UITableView *table;
  IBOutlet __weak MMAudioTrackCell *audioCell;
  IBOutlet __weak MMSubtitleTrackCell *subtitleCell;
  IBOutlet __weak id<MMTitleTrackTableDelegate> delegate;
  
  __strong MMAudioTrackCell *sizingAudioCell;
  __strong MMSubtitleTrackCell *sizingSubtitleCell;
  
  __strong MMTitle *title;
}

@property (nonatomic, readwrite, strong) MMTitle *title;

- (void) refresh;
- (CGFloat) totalHeightForAudioTracks: (NSArray *) audios andSubtitleTracks: (NSArray *) subtitles;
@end
