//
//  MMSubtitleTrackListView.h
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 Edmunds. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMSubtitleTrackView;

@protocol MMSubtitleTrackListViewDelegate <NSObject>
- (void) didSelectSubtitleTrackAtIndex: (NSInteger) index;
@end

@interface MMSubtitleTrackListView : UIView
{
  IBOutlet __strong UILabel *title;
  IBOutlet __weak MMSubtitleTrackView *subtitleTrackView;
  IBOutlet __weak id<MMSubtitleTrackListViewDelegate> delegate;
  
  __strong NSMutableArray *subtitleTrackViews;
}

- (void) setSubtitleTracks: (NSArray *) audioTracks;
- (void) tappedAudioTrack:(MMSubtitleTrackView *) trackView;

@end
