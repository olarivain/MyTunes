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

#import "MYTPlaylistContentDataSource.h"
#import "MYTMoviePlaylistDataSource.h"

#import "MYTLibraryStore.h"

@interface MYTPlaylistViewController ()<UITabBarDelegate> {
    dispatch_once_t initialPlaylistSelectionToken;
}
@property (strong, nonatomic) IBOutlet id<MYTPlaylistContentDataSource> moviePlaylistDataSource;
@property (strong, nonatomic) IBOutlet id<MYTPlaylistContentDataSource> tvShowPlaylistDataSource;

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISegmentedControl *filterSegmentedControl;

@property (weak, nonatomic) IBOutlet UITabBar *playlistTabBar;

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
    
    // 
    dispatch_once(&initialPlaylistSelectionToken, ^{
        [self refreshSelectedPlaylist];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - synthetic getter
- (id<MYTPlaylistContentDataSource>) currentDataSource {
	MMPlaylist *playlist = [MYTLibraryStore sharedInstance].currentPlaylist;
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
	[self.currentDataSource reload: self.showAll];
}

#pragma mark - tab bar delegate
- (void) tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [tabBar.items indexOfObject: item];
    
    MYTLibraryStore *store = [MYTLibraryStore sharedInstance];
    MMPlaylist *playlist = [store.currentLibrary.playlists boundSafeObjectAtIndex: index];
    
    // user tapped a playlist, go for it
    if(playlist != nil) {
        store.currentPlaylist = playlist;
        [self refreshSelectedPlaylist];
        return;
    }
}

#pragma mark - Updating the selection
- (void) refreshSelectedPlaylist {
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
        [self didLoadPlaylist: error];
    }];
}

- (void) didLoadPlaylist: (NSError *) error {
    if([error present]) {
        return;
    }
    
    [self.activityIndicator stopAnimating];
    [self.currentDataSource reload: self.showAll];
    
    // fade the table out and start the spinning spinner
	[UIView animateWithDuration: SHORT_ANIMATION_DURATION
                     animations:^{
                         self.table.alpha = 1.0f;
                     }];
}

//- (void) didSelectContent:(MMContent *)content {
//    NSArray *contentList = self.currentDataSource.content;
//    
//}

@end
