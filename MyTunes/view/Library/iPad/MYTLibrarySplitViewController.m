//
//  MYTLibraryViewController.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/20/13.
//
//

#import <MediaManagement/MMLibrary.h>

#import "MYTLibrarySplitViewController.h"

#import "MYTLibraryStore.h"

#import "MYTPlaylistViewController.h"

@interface MYTLibrarySplitViewController ()
@property (weak, nonatomic) IBOutlet UIView *masterContainer;
@property (strong, nonatomic) IBOutlet MYTPlaylistViewController *playlistController;
@end

@implementation MYTLibrarySplitViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [MYTLibraryStore sharedInstance].currentLibrary.name;
    
    [self addPlaylistViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMasterContainer:nil];
    [super viewDidUnload];
}

#pragma mark - View Controller containment
- (void) addPlaylistViewController {
	[self addChildViewController: self.playlistController];
    [self.playlistController didMoveToParentViewController: self];
    
    [self.masterContainer addSubview: self.playlistController.view];
    CGRect playlistFrame = self.playlistController.view.frame;
    playlistFrame.size = self.masterContainer.frame.size;
    playlistFrame.origin = CGPointZero;
    self.playlistController.view.frame = playlistFrame;
}
@end
