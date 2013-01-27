//
//  MediaManagementViewController.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//
#import <KraCommons/KCNibUtils.h>
#import <KraCommons/KCCarouselView.h>

#import "MYTHomeViewController.h"

#import "MYTServerStore.h"
#import "MYTServerStoreDelegate.h"
#import "MYTLibraryStore.h"

#import "MYTServer.h"

#import "MYTHomeView.h"
#import "MYTServerView.h"

#import "MYTLibrarySplitViewController.h"
#import "MYTPlaylistViewController.h"

@interface MYTHomeViewController()<MYTServerStoreDelegate, KCCarouselViewDelegate, KCCarouselViewDataSource> {
	dispatch_once_t tileDispatchToken;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet KCCarouselView *serverCarousel;
@property (weak, nonatomic, readwrite) IBOutlet MYTServerView *serverTile;

@property (assign, nonatomic) CGSize tileSize;

@end

@implementation MYTHomeViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
    
	// setup the carousel
	self.serverCarousel.style = KCCarouselViewStyleGrid;
	self.serverCarousel.contentPadding = 20.0f;
	
	// and fire the search. This is safe to do multiple times
	MYTServerStore *store = [MYTServerStore sharedInstance];
	[store startSearching];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self.serverCarousel reload];
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
	
	[self.serverCarousel reload];
	
}

- (void) didRemoveServer:(MYTServer *)server {
	NSArray *servers = [MYTServerStore sharedInstance].servers;
	if(servers.count == 0) {
		[self.activityIndicator startAnimating];
	}
	
	[self.serverCarousel reload];
}

#pragma mark - Carousel data source
- (NSUInteger) numberOfTilesInCarousel:(KCCarouselView *)carousel {
	return [MYTServerStore sharedInstance].servers.count;
}

- (CGSize) carousel:(KCCarouselView *)carousel sizeForTileAtIndex:(NSUInteger)index {
	dispatch_once(&tileDispatchToken, ^{
		NSBundle *bundle = [NSBundle mainBundle];
		NSString *nibName = [KCNibUtils nibName: @"MYTServerView"];
		[bundle loadNibNamed: nibName
					   owner: self
					 options: nil];
		self.tileSize = self.serverTile.frame.size;
	});
	return self.tileSize;
}

- (UIView *) carousel:(KCCarouselView *)carousel tileForIndex:(NSUInteger)index {
	MYTServerView *tile = [carousel dequeueResuableTile];
	if(tile == nil) {
		NSBundle *bundle = [NSBundle mainBundle];
		NSString *nibName = [KCNibUtils nibName: @"MYTServerView"];
		[bundle loadNibNamed: nibName
					   owner: self
					 options: nil];
		tile = self.serverTile;
		self.serverTile = nil;
	}
	
	NSArray *servers = [MYTServerStore sharedInstance].servers;
	MYTServer *server = [servers boundSafeObjectAtIndex: index];
	[tile updateWithServer: server];
	return tile;
}

#pragma mark - carousel delegate
- (void) carousel:(KCCarouselView *)carousel didSelectIndex:(NSUInteger)index {
	MYTServerStore *store = [MYTServerStore sharedInstance];
	NSArray *servers = store.servers;
	MYTServer *server = [servers boundSafeObjectAtIndex: index];
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
