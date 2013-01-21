//
//  MYTMovieCell.h
//  MyTunes
//
//  Created by Olivier Larivain on 1/21/13.
//
//

#import <UIKit/UIKit.h>

@class MMContent;

@interface MYTMovieCell : UITableViewCell

- (void) updateWithContent: (MMContent *) content;

@end
