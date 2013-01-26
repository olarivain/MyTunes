//
//  MYTPlaylistViewController.h
//  MyTunes
//
//  Created by Olivier Larivain on 1/20/13.
//
//

#import <UIKit/UIKit.h>

@class MMPlaylist;

@protocol MYTPlaylistControllerDelegate <NSObject>

- (void) didSelectPlaylist: (MMPlaylist *) playlist;

@end

@interface MYTLibraryListViewController : UIViewController

@end
