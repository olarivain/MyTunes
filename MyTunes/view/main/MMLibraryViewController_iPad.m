//
//  MainViewController_iPad.m
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <KraCommons/KCNibUtils.h>

#import <MediaManagement/MMPlaylist.h>

#import "MMLibraryViewController_iPad.h"

#import "MYTServer.h"
#import "MMRemoteLibrary.h"
#import "MMRemotePlaylist.h"
#import "MMRemoteEncoder.h"

#import "MMEditController_iPad.h"
#import "MMPlaylistContentTableController.h"
#import "MMContentView.h"
#import "MMPlaylistSubcontentSelector.h"
#import "MMTitleListSummaryTableController.h"

@interface MMLibraryViewController_iPad()
@end

@implementation MMLibraryViewController_iPad

@synthesize server;

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void) viewDidLoad
{
	[super viewDidLoad];
	
	// initialize playlist table controller
	libraryNavigationTableController.library = server.library;
	
	// auto select first item in system playlist if there is one available
	[libraryNavigationTableController selectPlaylist: playlistContentController.playlist];
	
	// update title bar
	[[self navigationItem] setTitle: [server name]];
	
}

- (void)viewDidUnload
{
	libraryNavigationTableController = nil;
	playlistContentController = nil;
	[super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations
	return YES;
}

#pragma mark - Playlist table controller delegate
- (void) didSelectPlaylist:(MMPlaylist *)playlist
{
	encoderView.hidden = YES;
	playlistContentView.hidden = NO;
	
	// tapped the same playlist again, give up
	if(playlistContentController.playlist == playlist)
	{
		return;
	}
	
	// retain current playlist
	playlistContentController.playlist = playlist;
	
	// tell controller to refresh its content
	[playlistContentController refresh];
}

- (void) didSelectEncoderResources
{
	encoderView.hidden = NO;
	playlistContentView.hidden = YES;
	
	// display visual feedback
	encoderTableController.encoder = server.encoder;
	[encoderTableController refresh];
}

@end
