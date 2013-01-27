//
//  MYTTVShowHeader.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/26/13.
//
//
#import <KraCommons/UIButton+ResizableImage.h>
#import "MYTTVShowHeader.h"

#import "MMTVShowSeason.h"

@interface MYTTVShowHeader ()
@property (weak, nonatomic) IBOutlet UILabel *seasonLabel;
@property (weak, nonatomic) IBOutlet UIButton *headerButton;
@property (strong, nonatomic, readwrite) MMTVShowSeason *season;

@end

@implementation MYTTVShowHeader

- (void) awakeFromNib {
    UIEdgeInsets inset = UIEdgeInsetsMake(20, 20, 20, 20);
	[self.headerButton updateBackgroundWithResizableCaps: inset];
}

- (void) prepareForReuse {
    self.season = nil;
}

- (void) updateWithShow: (MMTVShowSeason *) season {
    self.seasonLabel.text = [season humanReadableName];
    self.season = season;
    
    NSString *buttonName = season.isUnplayed ? @"Watched" : @"Unwatch" ;
    [self.headerButton setTitle: buttonName forState: UIControlStateNormal];
    [self.headerButton setTitle: buttonName forState: UIControlStateHighlighted];
}

- (IBAction) markAsViewed:(id)sender {
    [self.delegate didMarkAsViewed: self.season];
}

@end
