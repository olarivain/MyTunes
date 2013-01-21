//
//  MYTMovieCell.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/21/13.
//
//

#import <MediaManagement/MMContent.h>

#import "MYTMovieCell.h"

@interface MYTMovieCell () {
	CGSize _constrainedSize;
}

@property (weak, nonatomic) IBOutlet UIImageView *unplayedIcon;
@property (weak, nonatomic) IBOutlet UILabel *movieLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@end



@implementation MYTMovieCell

- (void) awakeFromNib {
	_constrainedSize = self.movieLabel.frame.size;
	_constrainedSize.height = CGFLOAT_MAX;
}

- (void) updateWithContent: (MMContent *) content {
	self.movieLabel.text = content.name;
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
