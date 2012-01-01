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

@interface MMTitleTrackTableController : NSObject<UITableViewDelegate, UITableViewDataSource>
{
  IBOutlet __strong UITableView *table;
  IBOutlet __weak MMAudioTrackCell *audioCell;
  IBOutlet __weak MMSubtitleTrackCell *subtitleCell;
  
  __strong MMAudioTrackCell *sizingAudioCell;
  __strong NSArray *audioTracks;
  
  __strong MMSubtitleTrackCell *sizingSubtitleCell;
  __strong NSArray *subtitleTracks;
}

@property (nonatomic, readwrite, strong) NSArray *audioTracks;
@property (nonatomic, readwrite, strong) NSArray *subtitleTracks;

- (void) refresh;
- (CGFloat) totalHeightForAudioTracks: (NSArray *) audios andSubtitleTracks: (NSArray *) subtitles;
@end
