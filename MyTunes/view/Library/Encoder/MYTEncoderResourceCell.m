//
//  MYTEncoderResourceCell.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/26/13.
//
//
#import <MediaManagement/MMTitleList.h>
#import <MediaManagement/MMTitle.h>
#import "MYTEncoderResourceCell.h"

@interface MYTEncoderResourceCell () {
    CGSize _constrainedNameSize;
    CGSize _constrainedProgressSize;
}
@property (weak, nonatomic) IBOutlet UIImageView *checkmark;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *progress;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation MYTEncoderResourceCell

- (void) awakeFromNib {
    _constrainedNameSize = self.name.frame.size;
    _constrainedNameSize.height = CGFLOAT_MAX;
    
    _constrainedProgressSize = self.progress.frame.size;
    _constrainedProgressSize.height = CGFLOAT_MAX;
}

- (void) updateWithTitleList: (MMTitleList *) titleList {
	self.checkmark.hidden = titleList.selectedTitles.count == 0 || titleList.active;
    self.name.text = titleList.name;

    if(self.progress == nil) {
        return;
    }
    
    NSString *progressString = [self progressStringForTitleList: titleList];
    self.progress.text = progressString;
    self.progressView.progress = ((float) titleList.activeTitle.progress) / 100.0f;
}

- (NSString *) progressStringForTitleList: (MMTitleList *) titleList {
    return [NSString stringWithFormat: @"Title %i of %i, %@ remaining", titleList.completedCount,
                                titleList.selectedCount, titleList.name];
}

- (CGFloat) idealHeightForTitleList:(MMTitleList *)titleList {
    CGSize nameSize = [titleList.name sizeWithFont: self.name.font
                                 constrainedToSize: _constrainedNameSize
                                     lineBreakMode: self.name.lineBreakMode];
    if(self.progress == nil) {
        return nameSize.height + 2 * CGRectGetMinY(self.name.frame);
    }
    
    NSString *progressString = [self progressStringForTitleList: titleList];
    CGSize progressSize = [progressString sizeWithFont: self.progress.font
                                     constrainedToSize: _constrainedProgressSize
                                         lineBreakMode: self.progress.lineBreakMode];
    
    CGFloat nameDiff = nameSize.height - self.name.frame.size.height;
    CGFloat progressDiff = progressSize.height - self.progress.frame.size.height;
    
    return self.frame.size.height + nameDiff + progressDiff;
    
}

@end
