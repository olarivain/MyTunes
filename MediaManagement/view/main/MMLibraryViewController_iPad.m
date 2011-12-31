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

#import "MMEditController_iPad.h"
#import "MMPlaylistContentTableController.h"
#import "MMContentView.h"
#import "MMPlaylistSubcontentSelector.h"

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
  playlistTableController.library = server.library;
  
  // auto select first item in system playlist if there is one available
  if(selectedPlaylist == nil) 
  {
    [playlistTableController selectFirstPlaylist];
  }
  
  // update title bar
  [[self navigationItem] setTitle: [server name]];
  
}

- (void)viewDidUnload
{
  editButton = nil;
  contentView = nil;
  playlistTableController = nil;
  contentController = nil;
  [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear: animated];
  
  // udpate right bar button item
  self.navigationItem.rightBarButtonItem = editButton;
}

- (void) viewWillDisappear:(BOOL)animated
{
  self.navigationItem.rightBarButtonItem = nil;
  [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return YES;
}

#pragma mark - Playlist table controller delegate
- (void) didSelectPlaylist:(MMPlaylist *)playlist
{   
  // tapped the same playlist again, give up
  if(playlist == selectedPlaylist)
  {
    return;
  }
  
  // retain current playlist
  selectedPlaylist = playlist;
  
  // display visual feedback
  [contentView setLoading: TRUE];
  
  // clear content view
  contentController.playlist = nil;
  [contentController refresh];
  
  // refresh content on callback
  MMPlaylistCallback callback = ^(void) {
    contentController.playlist = selectedPlaylist;
    [contentController refresh];
    [contentView setLoading: FALSE];
  };
  
  // load playlist
  [selectedPlaylist loadWithBlock: callback];
}

#pragma mark - Action handlers
- (IBAction) editPressed: (id) sender
{
  // grab a handle on the next view controller
  NSString *nibName = [NibUtils nibName: @"MMEditController"];
  MMEditController_iPad *editController = [[MMEditController_iPad alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
  editController.currentItem = contentController.selectedItem;
  editController.contentGroup = contentController.selectedContentGroup;
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
  [contentController refresh];
}

@end
 