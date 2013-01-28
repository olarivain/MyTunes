//
//  MYTMovieCell.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/21/13.
//
//

#import <MediaManagement/MMContent.h>

#import "MYTContentCell.h"

@interface MYTContentCell () {
	CGSize _constrainedSize;
}

@property (weak, nonatomic) IBOutlet UIImageView *unplayedIcon;
@property (weak, nonatomic) IBOutlet UILabel *episodeNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@property (strong, nonatomic) UIColor *episodeOriginalColor;
@property (strong, nonatomic) UIColor *labelOriginalColor;
@property (strong, nonatomic) UIColor *durationOriginalColor;

@end



@implementation MYTContentCell

- (void) awakeFromNib {
	_constrainedSize = self.movieLabel.frame.size;
	_constrainedSize.height = CGFLOAT_MAX;
    
    self.episodeOriginalColor = self.episodeNumberLabel.textColor;
    self.labelOriginalColor = self.movieLabel.textColor;
    self.durationOriginalColor = self.durationLabel.textColor;
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected: selected animated: animated];
    
    self.episodeNumberLabel.textColor = self.editing && selected ? [UIColor blackColor] : self.episodeOriginalColor;
    self.movieLabel.textColor = self.editing && selected ? [UIColor blackColor] :  self.labelOriginalColor;
    self.durationLabel.textColor = self.editing && selected ? [UIColor blackColor] :  self.durationOriginalColor;
    
}

- (void) updateWithContent: (MMContent *) content {
	self.movieLabel.text = content.name;
	self.episodeNumberLabel.text = [content.episodeNumber nonZeroStringValue];
	self.durationLabel.text = content.durationHumanReadable;
	self.unplayedIcon.hidden = !content.unplayed;
}

#pragma mark - sizing code
- (void) resizeTo: (CGSize) newSize {
	// update our frame
	CGRect frame = self.frame;
	frame.size = newSize;
	self.frame = frame;
	
	// and update the constrained size
	_constrainedSize = self.movieLabel.frame.size;
	_constrainedSize.height = CGFLOAT_MAX;
}

- (CGFloat) idealHeightForContent: (MMContent *) content {
	CGSize size = [content.name sizeWithFont: self.movieLabel.font
						   constrainedToSize: _constrainedSize
							   lineBreakMode: self.movieLabel.lineBreakMode];
	
    CGFloat totalHeight = size.height + 2 * CGRectGetMinY(self.movieLabel.frame);
	return MAX(totalHeight, 44);
}

@end
