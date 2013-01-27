//
//  MYTTVShowHeader.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/26/13.
//
//

#import "MYTTVShowHeader.h"

#import "MMTVShowSeason.h"

@interface MYTTVShowHeader ()
@property (weak, nonatomic) IBOutlet UILabel *seasonLabel;

@end

@implementation MYTTVShowHeader

- (void) prepareForReuse {
    DDLogInfo(@"dequeuing...");
}

- (void) updateWithShow: (MMTVShowSeason *) season {
    self.seasonLabel.text = [season humanReadableName];
}

@end
