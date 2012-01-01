//
//  MMAudioTrackView.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 Edmunds. All rights reserved.
//

#import <MediaManagement/MMAudioTrack.h>

#import "MMAudioTrackCell.h"

@interface MMAudioTrackCell()
- (NSString *) audioLabelFromTrack: (MMAudioTrack *) track;
@end

@implementation MMAudioTrackCell

- (void) updateWithAudioTrack:(MMAudioTrack *)track
{
  NSString *title = [self audioLabelFromTrack: track];
  trackLabel.text = title;
  
  checkmarkView.hidden = !track.selected;
}

- (NSString *) audioLabelFromTrack:(MMAudioTrack *)track
{
  NSString *codec = nil;
  switch (track.codec) 
  {
    case AUDIO_CODEC_AC3:
      codec = @"Dolby Digital";
      break;
    case AUDIO_CODEC_AAC:
      codec = @"AAC";
      break;
    case AUDIO_CODEC_DTS:
      codec = @"DTS";
      break;
    case AUDIO_CODEC_LINEAR_PCM:
      codec = @"Linear PCM";
      break;
    case AUDIO_CODEC_MP3:
      codec = @"MP3";
      break;
    case AUDIO_CODEC_VORBIS:
      codec = @"Vorbis";
      break;
    case AUDIO_CODEC_UNKNOWN:
      codec = @"Unknown Codec";
      break;
    default:
      break;
  }
  
  NSString *language = [[NSLocale currentLocale] displayNameForKey: NSLocaleIdentifier value: track.language];
  NSString *label = [NSString stringWithFormat: @"%@ - %@, %i.%i", language, codec, track.channelCount, track.hasLFE];
  return label;
}

- (void) hidesSeparator: (BOOL) hide
{
  separator.hidden = hide;
}

@end
