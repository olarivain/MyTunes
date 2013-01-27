//
//  MYTTitleCell.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/27/13.
//
//
#import <MediaManagement/MMTitle.h>
#import "MYTTitleCell.h"

@interface MYTTitleCell ()
@property (weak, nonatomic) IBOutlet UIImageView *checkmark;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@end

@implementation MYTTitleCell

- (void) updateWithTitle: (MMTitle *) title {
	self.checkmark.hidden = !title.selected;
	self.titleLabel.text = [NSString stringWithFormat: @"Title %i", title.index];
	self.durationLabel.text = title.formatedDuration;
    [self.durationLabel sizeToFit];
}

@end
