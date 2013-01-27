//
//  MYTAudioTrackCell.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/27/13.
//
//
#import <MediaManagement/MMAudioTrack.h>
#import <MediaManagement/MMSubtitleTrack.h>

#import "MYTAudioSubtitleTrackCell.h"

@interface MYTAudioSubtitleTrackCell ()
@property (weak, nonatomic) IBOutlet UIImageView *checkmark;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation MYTAudioSubtitleTrackCell

#pragma mark - Audio
- (void) updateWithAudioTrack: (MMAudioTrack *) track {
	self.checkmark.hidden = !track.selected;
	self.name.text = [self audioLabelFromTrack: track];
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

#pragma mark - Subtitle
- (void) updateWithSubtitleTrack: (MMSubtitleTrack *) track {
	self.checkmark.hidden = !track.selected;
	self.name.text = [self subtitleLabelFromTrack: track];
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


@end
