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

#import "MYTLibraryListViewController.h"
#import "MYTPlaylistViewController.h"

@interface MYTLibrarySplitViewController ()<MYTPlaylistControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *masterContainer;
@property (weak, nonatomic) IBOutlet UIView *detailsContainer;
@property (strong, nonatomic) IBOutlet MYTLibraryListViewController *libraryController;
@property (strong, nonatomic) IBOutlet MYTPlaylistViewController *playlistViewController;
@end

@implementation MYTLibrarySplitViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [MYTLibraryStore sharedInstance].currentLibrary.name;
    
    // add the subview controllers
    [self addViewController: self.libraryController
                     toView: self.masterContainer];
    [self addViewController: self.playlistViewController
                     toView: self.detailsContainer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    self.libraryController = nil;
    self.playlistViewController = nil;
    [super viewDidUnload];
}

#pragma mark - View Controller containment
- (void) addViewController: (UIViewController *) controller toView: (UIView *) view {
    [self addChildViewController: controller];
    [controller didMoveToParentViewController: self];
    
    [view addSubview: controller.view];
    CGRect playlistFrame = controller.view.frame;
    playlistFrame.size = view.frame.size;
    playlistFrame.origin = CGPointZero;
    controller.view.frame = playlistFrame;
}

#pragma mark - playlist delegate
- (void) didSelectPlaylist:(MMPlaylist *)playlist {
    [self.playlistViewController refreshSelectedPlaylist];
}
@end
