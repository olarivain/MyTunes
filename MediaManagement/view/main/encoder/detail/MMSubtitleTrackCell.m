//
//  MMSubtitleTrackView.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 Edmunds. All rights reserved.
//

#import <MediaManagement/MMSubtitleTrack.h>

#import "MMSubtitleTrackCell.h"

@interface MMSubtitleTrackCell()
- (NSString *) subtitleLabelFromTrack:(MMSubtitleTrack *)track;
@end

@implementation MMSubtitleTrackCell

- (void) updateWithSubtitleTrack:(MMSubtitleTrack *)track
{
  NSString *title = [self subtitleLabelFromTrack: track];
  trackLabel.text = title;
}

- (NSString *) subtitleLabelFromTrack:(MMSubtitleTrack *)track
{
  NSString *subtitle = nil;
  switch (track.type) 
  {
    case SUBTITLE_VOBSUB:
      subtitle = @"VOBSUB";
      break;
    case SUBTITLE_CLOSED_CAPTION:
      subtitle = @"Closed Caption";
      break;
    default:
      break;
  }
  
  NSString *language = [[NSLocale currentLocale] displayNameForKey: NSLocaleIdentifier value: track.language];
  NSString *label = [NSString stringWithFormat: @"%@ - %@", language, subtitle];
  return label;
}

- (void) hidesSeparator: (BOOL) hide
{
  separator.hidden = hide;
}

@end
