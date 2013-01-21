//
//  MYTMovieCell.h
//  MyTunes
//
//  Created by Olivier Larivain on 1/21/13.
//
//

#import <UIKit/UIKit.h>

@class MMContent;

@interface MYTContentCell : UITableViewCell

- (void) updateWithContent: (MMContent *) content;

- (void) resizeTo: (CGSize) newSize;
- (CGFloat) idealHeightForContent: (MMContent *) content;

@end
