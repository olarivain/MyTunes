//
//  MYTPlaylistViewController.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/21/13.
//
//
#import <MediaManagement/MMPlaylist.h>
#import <MediaManagement/MMLibrary.h>
#import "MYTPlaylistViewController.h"

#import "MYTLibraryStore.h"
#import "MYTEncoderStore.h"

#import "MYTPlaylistContentDataSource.h"
#import "MYTMoviePlaylistDataSource.h"
#import "MYTEncoderDataSource.h"

#import "MYTEditViewController.h"
#import "MYTTitleListViewController.h"

@interface MYTPlaylistViewController ()<UITabBarDelegate> {
    dispatch_once_t initialPlaylistSelectionToken;
}
@property (strong, nonatomic) IBOutlet id<MYTPlaylistContentDataSource> moviePlaylistDataSource;
@property (strong, nonatomic) IBOutlet id<MYTPlaylistContentDataSource> tvShowPlaylistDataSource;
@property (strong, nonatomic) IBOutlet MYTEncoderDataSource *encoderResources;

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISegmentedControl *filterSegmentedControl;

@property (weak, nonatomic) IBOutlet UITabBar *playlistTabBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@property (nonatomic, readonly) id<MYTPlaylistContentDataSource> currentDataSource;
@property (assign, nonatomic) BOOL showAll;

@end

@implementation MYTPlaylistViewController

#pragma mark - view lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.filterSegmentedControl.selectedSegmentIndex = self.showAll;
    
    self.title = [MYTLibraryStore sharedInstance].currentLibrary.name;
    UIViewController *parent = self.parentViewController;
    if([parent isKindOfClass: UINavigationController.class]) {
        parent = self;
    }
    parent.navigationItem.rightBarButtonItem = self.refreshButton;
    
    // iOS 6 only, meaning viewDidLoad happens once and only once.
    // so just get crazy and refresh on did load :)
    [self refreshSelectedPlaylist: NO];
    
    // same applies for the tab bar buddy!
    self.playlistTabBar.selectedItem = [self.playlistTabBar.items boundSafeObjectAtIndex: 0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - synthetic getter
- (id<MYTPlaylistContentDataSource>) currentDataSource {
	MMPlaylist *playlist = [MYTLibraryStore sharedInstance].currentPlaylist;
    if(playlist ==  nil) {
        return nil;
    }
    
    switch (playlist.kind) {
        case MOVIE:
			return self.moviePlaylistDataSource;
		case TV_SHOW:
			return self.tvShowPlaylistDataSource;
        default:
            break;
    }
	
	return nil;
}

#pragma mark - Switching between unwatched/all
- (IBAction)updateFilter:(id)sender {
    self.showAll = self.filterSegmentedControl.selectedSegmentIndex;
    
    MMPlaylist *playlist = [MYTLibraryStore sharedInstance].currentPlaylist;
    if(playlist != nil) {
        [self.currentDataSource reload: self.showAll];
        return;
    }
    
    [self.encoderResources reload: self.showAll];;
}

#pragma mark - Refreshing the content
- (IBAction)forceRefresh:(id)sender {
    if(self.currentDataSource != nil) {
        [self refreshSelectedPlaylist: NO];
        return;
    }
    
    [self refreshEncoderResources: NO];
}

#pragma mark - tab bar delegate
- (void) tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {

    NSInteger index = [tabBar.items indexOfObject: item];
    
    MYTLibraryStore *store = [MYTLibraryStore sharedInstance];
    MMPlaylist *playlist = [store.currentLibrary.playlists boundSafeObjectAtIndex: index];
    
    // user tapped a playlist, different than the one we have, go for it
    if(playlist != nil && playlist != store.currentPlaylist) {
        store.currentPlaylist = playlist;
        [self refreshSelectedPlaylist: YES];
        return;
    }
    
    // user tapped the encoder tab again, do nothing
    if(self.table.dataSource == self.encoderResources) {
        return;
    }
    [self refreshEncoderResources: YES];
}

#pragma mark - Updating the playlist
- (void) refreshSelectedPlaylist: (BOOL) resetContentOffset {
    // update the segemented control "filter" item
    [self.filterSegmentedControl setTitle: @"Unwatched"
                        forSegmentAtIndex: 0];
    
    MMPlaylist *playlist = [MYTLibraryStore sharedInstance].currentPlaylist;
	
	// inject the playlist in the data source
	id<MYTPlaylistContentDataSource> dataSource = self.currentDataSource;
	dataSource.playlist = playlist;
	
	// swap the data source on the table
	self.table.dataSource = dataSource;
	self.table.delegate = dataSource;
    
	// fade the table out and start the spinning spinner
	[UIView animateWithDuration: SHORT_ANIMATION_DURATION
                     animations:^{
                         self.table.alpha = 0.0f;
                     }];
	[self.activityIndicator startAnimating];
    
    // fire a load request
    MYTLibraryStore *store = [MYTLibraryStore sharedInstance];
    [store loadPlaylist:^(NSError *error) {
        [self didLoadPlaylist: error
           resetContentOffset: resetContentOffset];
    }];
}

- (void) didLoadPlaylist: (NSError *) error
      resetContentOffset: (BOOL) resetContentOffset{
    if([error present]) {
        return;
    }
    
    [self.activityIndicator stopAnimating];
    if(resetContentOffset) {
        self.table.contentOffset = CGPointZero;
    }
    [self.currentDataSource reload: self.showAll];
    
    // fade the table out and start the spinning spinner
	[UIView animateWithDuration: SHORT_ANIMATION_DURATION
                     animations:^{
                         self.table.alpha = 1.0f;
                     }];
}

#pragma mark - Updating the encoder
- (void) refreshEncoderResources: (BOOL) resetContentOffset {
    // update the segemented control "filter" item
    [self.filterSegmentedControl setTitle: @"Scheduled"
                        forSegmentAtIndex: 0];
    
    MYTLibraryStore *libraryStore = [MYTLibraryStore sharedInstance];
    libraryStore.currentPlaylist = nil;
    
	// fade the table out and start the spinning spinner
	[UIView animateWithDuration: SHORT_ANIMATION_DURATION
                     animations:^{
                         self.table.alpha = 0.0f;
                     }];
	[self.activityIndicator startAnimating];
    
    MYTEncoderStore *store = [MYTEncoderStore sharedInstance];
    [store loadEncoderResources:^(NSError *error) {
        [self didLoadEncoderResources: error
                   resetContentOffset: resetContentOffset];
    }];
}

- (void) didLoadEncoderResources: (NSError *) error
              resetContentOffset: (BOOL) resetContentOffset{
    if([error present]) {
        return;
    }
    
    // swap the data source on the table
	self.table.dataSource = self.encoderResources;
	self.table.delegate = self.encoderResources;
    
    [self.activityIndicator stopAnimating];
    if(resetContentOffset) {
        self.table.contentOffset = CGPointZero;
    }
    [self.encoderResources reload: self.showAll];

	[UIView animateWithDuration: SHORT_ANIMATION_DURATION
                     animations:^{
                         self.table.alpha = 1.0f;
                     }];
}

#pragma mark - Playlist data source delegate
- (void) didSelectContent: (MMContent *) content
          withContentList: (NSArray *) contentList {
    
    MYTEditViewController *controller = [[MYTEditViewController alloc] initWithNibName: @"MYTEditViewController"
                                                                                              bundle: nil];
    controller.contentList = contentList;
    controller.index = [contentList indexOfObject: content];
    controller.dismissBlock = ^(BOOL saved) {
        [self.currentDataSource deselectCurrentCell];
        if(saved) {
            [self.currentDataSource reload: self.showAll];
        }
    };

    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController: controller];
    navigation.modalPresentationStyle = UIModalPresentationFormSheet;
    navigation.modalTransitionStyle = isiPhone ? UIModalTransitionStyleFlipHorizontal : UIModalTransitionStyleCoverVertical;
    [self presentViewController: navigation
                       animated: YES
                     completion: nil];
}

- (void) didSelectTitleList:(MMTitleList *)titleList {
    MYTTitleListViewController *controller = [[MYTTitleListViewController alloc] initWithNibName: @"MYTTitleListViewController"
                                                                                          bundle: nil];
    
    controller.titleList = titleList;
    controller.dismissBlock = ^(BOOL saved) {
        [self.encoderResources deselectCurrentCell];
        if(saved) {
            [self.encoderResources reload: self.showAll];
        }
    };
    
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController: controller];
    navigation.modalPresentationStyle = UIModalPresentationFormSheet;
    navigation.modalTransitionStyle = isiPhone ? UIModalTransitionStyleFlipHorizontal : UIModalTransitionStyleCoverVertical;
    [self presentViewController: navigation
                       animated: YES
                     completion: nil];
}

@end
