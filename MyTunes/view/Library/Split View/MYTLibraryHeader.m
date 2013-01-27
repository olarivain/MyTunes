//
//  MYTLibraryHeader.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/26/13.
//
//

#import "MYTLibraryHeader.h"

@interface MYTLibraryHeader()
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation MYTLibraryHeader

- (void) updateWithTitle: (NSString *) title {
	self.title.text = title;
}

@end
