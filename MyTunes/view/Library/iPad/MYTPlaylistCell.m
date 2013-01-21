//
//  MYTPlaylistCell.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/21/13.
//
//

#import "MYTPlaylistCell.h"

@interface MYTPlaylistCell ()
@property (nonatomic, weak, readwrite) IBOutlet UILabel *playlistName;
@end

@implementation MYTPlaylistCell

- (void) updateWithTitle: (NSString *) title {
    self.playlistName.text = title;
}

@end
