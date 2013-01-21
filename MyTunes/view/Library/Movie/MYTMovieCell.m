//
//  MYTMovieCell.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/21/13.
//
//

#import <MediaManagement/MMContent.h>

#import "MYTMovieCell.h"

@interface MYTMovieCell ()

@property (weak, nonatomic) IBOutlet UILabel *movieLabel;

@end

@implementation MYTMovieCell

- (void) updateWithContent: (MMContent *) content {
	self.movieLabel.text = content.name;
}

@end
