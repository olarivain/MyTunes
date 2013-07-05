//
//  MediaManagementViewController.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//
#import <KraCommons/KCNibUtils.h>

#import "MYTHomeViewController.h"

#import "MYTServerStore.h"
#import "MYTServerStoreDelegate.h"
#import "MYTLibraryStore.h"

#import "MYTServer.h"

#import "MYTHomeView.h"
#import "MYTServerView.h"

#import "MYTLibrarySplitViewController.h"
#import "MYTPlaylistViewController.h"

@interface MYTHomeViewController()<MYTServerStoreDelegate, UICollectionViewDataSource, UICollectionViewDelegate> {
	dispatch_once_t tileDispatchToken;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UICollectionView *serverCarousel;
@property (weak, nonatomic, readwrite) IBOutlet MYTServerView *serverTile;

@property (assign, nonatomic) CGSize tileSize;

@end

@implementation MYTHomeViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
    
	// setup the collection view of servers
    NSString *nibName = [KCNibUtils nibName: @"MYTServerView"];
    [self.serverCarousel registerNib: [UINib nibWithNibName: nibName bundle:nil]
          forCellWithReuseIdentifier: @"server"];
	
	// and fire the search. This is safe to do multiple times
	MYTServerStore *store = [MYTServerStore sharedInstance];
	[store startSearching];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    [self.serverCarousel reloadData];
    for(NSIndexPath *indexPath in self.serverCarousel.indexPathsForSelectedItems) {
        [self.serverCarousel deselectItemAtIndexPath: indexPath
                                            animated: YES];
    }
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - ServerStore Delegate
- (void) didAddServer:(MYTServer *)server {
	// we have a new server, so stop the activity indicator
	[self.activityIndicator stopAnimating];
	
	[self.serverCarousel reloadData];
	
}

- (void) didRemoveServer:(MYTServer *)server {
	NSArray *servers = [MYTServerStore sharedInstance].servers;
	if(servers.count == 0) {
		[self.activityIndicator startAnimating];
	}
	
	[self.serverCarousel reloadData];
}

#pragma mark - Carousel data source
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [MYTServerStore sharedInstance].servers.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MYTServerView *tile = [collectionView dequeueReusableCellWithReuseIdentifier: @"server"
                                                                    forIndexPath: indexPath];
	
	NSArray *servers = [MYTServerStore sharedInstance].servers;
	MYTServer *server = [servers boundSafeObjectAtIndex: indexPath.row];
	[tile updateWithServer: server];
	return tile;

}

#pragma mark - carousel delegate
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    MYTServerStore *store = [MYTServerStore sharedInstance];
	NSArray *servers = store.servers;
	MYTServer *server = [servers boundSafeObjectAtIndex: indexPath.row];
	// the server just died below us, abort
	if(server == nil) {
		return;
	}
	
	[self.activityIndicator startAnimating];
    store.currentServer = server;
    
    MYTLibraryStore *libraryStore = [MYTLibraryStore sharedInstance];
    [libraryStore loadCurrentLibraryListing:^(NSError *error) {
        [self didLoadLibraryListing: error];
    }];

}

- (void) didLoadLibraryListing: (NSError *) error {
	[self.activityIndicator stopAnimating];
	if([error present]) {
        MYTServerStore *store = [MYTServerStore sharedInstance];
        store.currentServer = nil;
		return ;
	}
    
	// create the right view controller for the platform and configure it
    UIViewController *controller = nil;
    if(isiPad) {
        controller = [[MYTLibrarySplitViewController alloc] initWithNibName: @"MYTLibrarySplitViewController"
                                                                     bundle: nil];
    } else {
        controller = [[MYTPlaylistViewController alloc] initWithNibName: @"MYPlaylistTabViewController"
                                                                 bundle: nil];
    }
	
	[self.navigationController pushViewController: controller
										 animated: YES];
    
}

@end
