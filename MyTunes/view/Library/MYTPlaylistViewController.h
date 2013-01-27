//
//  MYTPlaylistViewController.h
//  MyTunes
//
//  Created by Olivier Larivain on 1/21/13.
//
//

#import <UIKit/UIKit.h>

#import "MYTPlaylistContentDataSource.h"

@interface MYTPlaylistViewController : UIViewController<MYTPlaylistContentDataSourceDelegate>

- (void) refreshSelectedPlaylist;
- (void) refreshEncoderResources;

@end
