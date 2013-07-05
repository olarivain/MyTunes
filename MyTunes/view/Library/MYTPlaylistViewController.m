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

#define  UNSUPPORTED_DELETE_TAG 1
#define  DELETE_CONFIRMATION_TAG 2

@interface MYTPlaylistViewController ()<UITabBarDelegate, UIAlertViewDelegate> {
    dispatch_once_t initialPlaylistSelectionToken;
}
@property (strong, nonatomic) IBOutlet id<MYTPlaylistContentDataSource> moviePlaylistDataSource;
@property (strong, nonatomic) IBOutlet id<MYTPlaylistContentDataSource> tvShowPlaylistDataSource;
@property (strong, nonatomic) IBOutlet MYTEncoderDataSource *encoderResources;

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISegmentedControl *filterSegmentedControl;

@property (weak, nonatomic) IBOutlet UITabBar *playlistTabBar;
@property (strong, nonatomic) IBOutlet IBOutletCollection(UIBarButtonItem) NSArray *defaultRightBarItems;
@property (strong, nonatomic) IBOutlet IBOutletCollection(UIBarButtonItem) NSArray *editRightBarItems;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteButton;

@property (nonatomic, readonly) id<MYTPlaylistContentDataSource> currentDataSource;
@property (assign, nonatomic) BOOL showAll;

@property (nonatomic, readonly) UIViewController *navigationItemController;
@property (weak, nonatomic) IBOutlet UIView *deleteShieldView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *deleteActivityIndicator;

@end

@implementation MYTPlaylistViewController

#pragma mark - view lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    if([self respondsToSelector: @selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIExtendedEdgeNone;
    }
    self.filterSegmentedControl.selectedSegmentIndex = self.showAll;
    
    self.title = [MYTLibraryStore sharedInstance].currentLibrary.name;
    
    self.navigationItemController.navigationItem.rightBarButtonItems = self.defaultRightBarItems;
    
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
- (UIViewController *) navigationItemController {
    UIViewController *parent = self.parentViewController;
    if([parent isKindOfClass: UINavigationController.class]) {
        parent = self;
    }
    return parent;
}

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

- (IBAction)edit:(id)sender {
	[self setEditing: YES animated: YES];
    [self.table setEditing: YES animated: YES];
    self.deleteButton.enabled = NO;
    [self.navigationItemController.navigationItem setRightBarButtonItems: self.editRightBarItems
                                                                animated: YES];
}

- (IBAction)cancel:(id)sender {
	[self setEditing: NO animated: YES];
    [self.table setEditing: NO animated: YES];
    [self.navigationItemController.navigationItem setRightBarButtonItems: self.defaultRightBarItems
                                                                animated: YES];
}

- (IBAction)deleteSelectedItems:(id)sender {
    if(self.currentDataSource != nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @""
                                                        message: @"Deleting iTunes content is not supported yet."
                                                       delegate: self
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        alert.tag = UNSUPPORTED_DELETE_TAG;
        [alert show];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @""
                                                    message: @"Are you sure you want to delete these items?"
                                                   delegate: self
                                          cancelButtonTitle: nil
                                          otherButtonTitles: @"Yes", @"No", nil];
    alert.cancelButtonIndex = 1;
    alert.tag = DELETE_CONFIRMATION_TAG;
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(alertView.tag == UNSUPPORTED_DELETE_TAG) {
        [self cancel: nil];
        return;
    }
    
    if(alertView.cancelButtonIndex == buttonIndex) {
        return;
    }
    
    [self deleteSelectedEncoderResources];
}

#pragma mark - Deleting resources
- (void) deleteSelectedEncoderResources {
    self.deleteShieldView.hidden = NO;
    [self.deleteActivityIndicator startAnimating];
    
    NSArray *selectedResources = self.encoderResources.selectedResources;
    
    MYTEncoderStore *store = [MYTEncoderStore sharedInstance];
    [store deleteResources: selectedResources
                  callback:^(NSError *error) {
                      [self didDeleteEncoderResources: error];
                  }];
}

- (void) didDeleteEncoderResources: (NSError *) error {
    [self.encoderResources reload: self.showAll];
    [self.deleteActivityIndicator stopAnimating];
    self.deleteShieldView.hidden = YES;
    
    [error present];
    [self refreshEncoderResources: NO];
    [self cancel: nil];
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
    if(self.editing) {
        self.deleteButton.enabled = [self.table indexPathsForSelectedRows].count > 0;
        return;
    }
    
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

- (void) didDeselectContent:(MMContent *)content withContentList:(NSArray *)contentList {
    self.deleteButton.enabled = [self.table indexPathsForSelectedRows].count > 0;
    return;
}

#pragma mark - Encoder data source delegate
- (void) didSelectTitleList:(MMTitleList *)titleList {
    if(self.editing) {
        self.deleteButton.enabled = [self.table indexPathsForSelectedRows].count > 0;
        return;
    }
    
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

- (void) didDeselectTitleList:(MMTitleList *)titleList {
    self.deleteButton.enabled = [self.table indexPathsForSelectedRows].count > 0;
}

@end
