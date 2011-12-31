//
//  MainViewController_iPad.m
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//
#import <MediaManagement/MMPlaylist.h>
#import <MediaManagement/MMContentGroup.h>

#import "MMLibraryViewController_iPad.h"

#import "MMServer.h"
#import "MMRemoteLibrary.h"
#import "MMRemotePlaylist.h"
#import "MMRemoteEncoder.h"

#import "MMEditController_iPad.h"
#import "MMPlaylistContentTableController.h"
#import "MMContentView.h"
#import "MMPlaylistSubcontentSelector.h"
#import "MMEncoderTableController.h"

#import "NibUtils.h"

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
  if(selectedPlaylist == nil) 
  {
    [libraryNavigationTableController selectFirstPlaylist];
  }
  
  // update title bar
  [[self navigationItem] setTitle: [server name]];
  
}

- (void)viewDidUnload
{
  playlistContentView = nil;
  encoderView = nil;
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
  if(playlist == selectedPlaylist)
  {
    return;
  }
  
  // retain current playlist
  selectedPlaylist = playlist;
  
  // display visual feedback
  [playlistContentView setLoading: TRUE];
  
  // clear content view
  playlistContentController.playlist = nil;
  [playlistContentController refresh];
  
  // refresh content on callback
  MMPlaylistCallback callback = ^{
    playlistContentController.playlist = selectedPlaylist;
    [playlistContentController refresh];
    [playlistContentView setLoading: FALSE];
  };
  
  // load playlist
  [selectedPlaylist loadWithBlock: callback];
}

- (void) didSelectEncoderResources
{
  encoderView.hidden = NO;
  playlistContentView.hidden = YES;
  
  // display visual feedback
  [encoderView setLoading: TRUE];
  encoderTableController.encoder = nil;
  [encoderTableController refresh];
  
  MMRemoteEncoderCallback callback = ^{
    [encoderView setLoading: NO];
    encoderTableController.encoder = server.encoder;
    [encoderTableController refresh];
  };
  
  [server.encoder loadAvailableResources: callback];
}

- (void) didSelectPendingEncodings
{
  encoderView.hidden = NO;
  playlistContentView.hidden = YES;
}

#pragma mark - Action handlers
- (IBAction) editPressed: (id) sender
{
  // grab a handle on the next view controller
  NSString *nibName = [NibUtils nibName: @"MMEditController"];
  MMEditController_iPad *editController = [[MMEditController_iPad alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
  editController.currentItem = playlistContentController.selectedItem;
  editController.contentGroup = playlistContentController.selectedContentGroup;
  editController.playlist = selectedPlaylist;
  editController.delegate = self;
  
  // and present it in a form sheet
  [editController setModalPresentationStyle: UIModalPresentationFormSheet];
  [self presentModalViewController:editController animated:TRUE];
}

#pragma mark - edit controller delegate
- (void) didEditContent:(MMContent *)item 
{
  // ask library to update shit and refresh
  [server.library updateContent: item];
  [playlistContentController refresh];
}

@end
 