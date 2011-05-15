//
//  MainViewController_iPad.m
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//
#import <MediaManagement/MMPlaylist.h>

#import "MMLibraryViewController_iPad.h"

#import "MMServer.h"
#import "MMRemoteLibrary.h"
#import "MMRemotePlaylist.h"

#import "MMEditController.h"
#import "MMPlaylistTableViewController.h"
#import "MMContentView.h"

@interface MMLibraryViewController_iPad()

@property (nonatomic, readwrite, retain) UIBarButtonItem *editButton;
@property (nonatomic, readwrite, retain) MMPlaylistTableViewController *contentController;
@property (nonatomic, readwrite, retain) MMContentView *contentView;

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
  [super dealloc];
}


@synthesize editButton;
@synthesize contentController;
@synthesize contentView;

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
  [super viewDidUnload];
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
  selectedPlaylist = playlist;
  
  [contentView setLoading: TRUE];
  
  [selectedPlaylist loadWithBlock:^(void) {
    contentController.playlist = selectedPlaylist;
    [contentController refresh];
    [contentView setLoading: FALSE];
  }];
}

#pragma mark - Action handlers
- (IBAction) editPressed: (id) sender
{
  NSString *nibName = @"EditController";
  MMEditController *editController = [[MMEditController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
  [editController setModalPresentationStyle:UIModalPresentationFormSheet];
  [self presentModalViewController:editController animated:TRUE];
  [editController release];
}

@end
 