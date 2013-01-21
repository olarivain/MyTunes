//
//  MediaManagementViewController.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//
#import <KraCommons/KCNibUtils.h>
#import <KraCommons/KCCarouselView.h>

#import "MMHomeViewController.h"

#import "MYTServerStore.h"
#import "MYTServerStoreDelegate.h"

#import "MMServer.h"
#import "MMRemoteLibrary.h"

#import "MMHomeView.h"
#import "MMServerView.h"

#import "MMLibraryViewController.h"
#import "MMLibraryViewController_iPad.h"
#import "MMLibraryViewController_iPhone.h"

@interface MMHomeViewController()<MYTServerStoreDelegate, KCCarouselViewDelegate, KCCarouselViewDataSource> {
	dispatch_once_t tileDispatchToken;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet KCCarouselView *serverCarousel;
@property (weak, nonatomic, readwrite) IBOutlet MMServerView *serverTile;
@property (assign, nonatomic) CGSize tileSize;
@end

@implementation MMHomeViewController

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

- (void)viewDidUnload
{
	[super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - ServerStore Delegate
- (void) didAddServer:(MMServer *)server {
	// we have a new server, so stop the activity indicator
	[self.activityIndicator stopAnimating];
	
	[self.serverCarousel reload];
	
}

- (void) didRemoveServer:(MMServer *)server {
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
		NSString *nibName = [KCNibUtils nibName: @"MMServerView"];
		[bundle loadNibNamed: nibName
					   owner: self
					 options: nil];
		self.tileSize = self.serverTile.frame.size;
	});
	return self.tileSize;
}

- (UIView *) carousel:(KCCarouselView *)carousel tileForIndex:(NSUInteger)index {
	MMServerView *tile = [carousel dequeueResuableTile];
	if(tile == nil) {
		NSBundle *bundle = [NSBundle mainBundle];
		NSString *nibName = [KCNibUtils nibName: @"MMServerView"];
		[bundle loadNibNamed: nibName
					   owner: self
					 options: nil];
		tile = self.serverTile;
		self.serverTile = nil;
	}
	
	NSArray *servers = [MYTServerStore sharedInstance].servers;
	MMServer *server = [servers boundSafeObjectAtIndex: index];
	[tile updateWithServer: server];
	return tile;
}

#pragma mark - carousel delegate
- (void) carousel:(KCCarouselView *)carousel didSelectIndex:(NSUInteger)index {
	MYTServerStore *store = [MYTServerStore sharedInstance];
	NSArray *servers = store.servers;
	MMServer *server = [servers boundSafeObjectAtIndex: index];
	// the server just died below us, abort
	if(server == nil) {
		return;
	}
	
	[self.activityIndicator startAnimating];
	KCErrorBlock callback = ^(NSError *error) {
		[self didSelectServer: error];
	};
	[store selectServer: server callback: callback];
}

- (void) didSelectServer: (NSError *) error {
	[self.activityIndicator stopAnimating];
	if([error present]) {
		return ;
	}
    
	// create the right view controller for the platform and configure it
	NSString *nibName = [KCNibUtils nibName: @"MMLibraryViewController"];
	Class clazz = isiPad ? [MMLibraryViewController_iPad class] : [MMLibraryViewController_iPhone class];
	UIViewController<MMLibraryViewController> *libraryViewController = [[clazz alloc] initWithNibName: nibName
																							   bundle: nil];
	libraryViewController.server = [MYTServerStore sharedInstance].currentServer;
	
	[self.navigationController pushViewController: libraryViewController
										 animated: YES];
    
}

- (UIViewController<MMLibraryViewController> *) loadLibraryController
{
    
}

@end
