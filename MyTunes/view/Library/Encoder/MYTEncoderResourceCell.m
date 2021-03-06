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
@property (weak, nonatomic) IBOutlet UIImageView *clock;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *progress;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (strong, nonatomic) UIColor *nameOriginalColor;
@property (strong, nonatomic) UIColor *progressOriginalColor;

@end

@implementation MYTEncoderResourceCell

- (void) awakeFromNib {
    _constrainedNameSize = self.name.frame.size;
    _constrainedNameSize.height = CGFLOAT_MAX;
    
    _constrainedProgressSize = self.progress.frame.size;
    _constrainedProgressSize.height = CGFLOAT_MAX;
    self.nameOriginalColor = self.name.textColor;
    self.progressOriginalColor = self.progress.textColor;
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected: selected animated: animated];
    
    self.name.textColor = self.editing && selected ? [UIColor blackColor] : self.nameOriginalColor;
    self.progress.textColor = self.editing && selected ? [UIColor blackColor] :  self.progressOriginalColor;
}

- (void) updateWithTitleList: (MMTitleList *) titleList
                  showingAll: (BOOL) showingAll {
    self.clock.hidden = !showingAll || titleList.completedCount == titleList.selectedCount;
    self.checkmark.hidden = titleList.selectedCount == 0 || titleList.selectedCount != titleList.completedCount;
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
                                titleList.selectedCount, titleList.activeTitle.formattedEta];
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
