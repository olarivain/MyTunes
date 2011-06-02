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
#import "MMPlaylistTableViewController.h"
#import "MMContentView.h"
#import "MMPlaylistSubcontentSelector.h"

#import "NibUtils.h"

@interface MMLibraryViewController_iPad()

@property (nonatomic, readwrite, retain) UIBarButtonItem *editButton;
@property (nonatomic, readwrite, retain) MMPlaylistTableViewController *contentController;
@property (nonatomic, readwrite, retain) MMContentView *contentView;
@property (nonatomic, readwrite, retain) MMPlaylistSubcontentSelector *subcontentSelector;
@property (nonatomic, readwrite, retain) UITableView *playlistTable;

- (NSArray*) playlistListForIndex: (NSInteger) index;
- (NSArray*) playlistListForIndexPath: (NSIndexPath*) indexPath;
- (MMPlaylist*) playlistForIndexPath: (NSIndexPath*) indexPath;
@end

@implementation MMLibraryViewController_iPad

- (void) dealloc
{
  self.editButton = nil;
  self.contentController = nil;
  self.contentView = nil;
  self.subcontentSelector = nil;
  self.selectedPlaylist = nil;
  self.playlistTable = nil;
  [super dealloc];
}


@synthesize editButton;
@synthesize contentController;
@synthesize contentView;
@synthesize subcontentSelector;
@synthesize playlistTable;

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void) viewDidLoad
{
  [super viewDidLoad];
  [[self navigationItem] setTitle: [server name]];
  
}

- (void)viewDidUnload
{
  self.editButton = nil;
  self.contentView = nil;
  self.subcontentSelector = nil;
  self.playlistTable = nil;
  [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear: animated];
  self.navigationItem.rightBarButtonItem = editButton;
  if(selectedPlaylist == nil) {
    NSIndexPath *path = [NSIndexPath indexPathForRow: 0 inSection: 0];
    [playlistTable selectRowAtIndexPath: path animated: NO scrollPosition:UITableViewScrollPositionTop];
    [self tableView: playlistTable didSelectRowAtIndexPath: path];

  }

}

- (void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationItem.rightBarButtonItem = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return YES;
}

#pragma mark - TableView Data source
#pragma Convienence accessors
- (NSArray*) playlistListForIndex: (NSInteger) index
{
  return  [self playlistListForIndexPath: [NSIndexPath indexPathForRow: 0 inSection: index]];
}

- (NSArray*) playlistListForIndexPath: (NSIndexPath*) indexPath
{
  MMRemoteLibrary *library = server.library;
  
  NSArray *playlists = indexPath.section == 0 ? library.systemPlaylists : library.userPlaylists;
  return playlists;
}

- (MMPlaylist*) playlistForIndexPath: (NSIndexPath*) indexPath
{
  NSArray *playlists = [self playlistListForIndexPath: indexPath];
  MMPlaylist *playlist = [playlists objectAtIndex: indexPath.row];
  return playlist;
}

#pragma mark Data Source methods
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSArray *playlists = [self playlistListForIndex: section];
  return [playlists count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  MMPlaylist *playlist = [self playlistForIndexPath: indexPath];
  
  NSString *cellId = @"playlistCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellId];
  if(cell == nil)
  {
    cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellId] autorelease];
  }
  
  cell.textLabel.text = playlist.name;
  return cell;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return section == 0 ? @"Library" : @"Playlists";
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{ 
  
  // tapped the same playlist again, give up
  MMPlaylist *playlist = [self playlistForIndexPath: indexPath];
  if(playlist == selectedPlaylist)
  {
    return;
  }
  self.selectedPlaylist = playlist;
  
  [contentView setLoading: TRUE];
  
  [selectedPlaylist loadWithBlock:^(void) {
    subcontentSelector.contentGroups = selectedPlaylist.contentGroups;
    
    [contentController refresh];
    [contentView setLoading: FALSE];
  }];
}

#pragma mark - Action handlers
- (IBAction) editPressed: (id) sender
{
  NSString *nibName = [NibUtils nibName: @"MMEditController"];
  MMEditController_iPad *editController = [[MMEditController_iPad alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
  editController.currentItem = contentController.selectedItem;
  editController.contentGroup = contentController.selectedContentGroup;
  editController.playlist = selectedPlaylist;
  
  [editController setModalPresentationStyle: UIModalPresentationFormSheet];
  [self presentModalViewController:editController animated:TRUE];
  [editController release];
}

- (IBAction) selectedPlaylistContentType: (id) sender
{
  selectedContentGroup = [subcontentSelector selectedContentGroup];
  contentController.selectedContentGroup = selectedContentGroup;
  [contentController refresh];
}

@end
 