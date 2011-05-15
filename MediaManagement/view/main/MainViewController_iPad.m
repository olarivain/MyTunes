//
//  MainViewController_iPad.m
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//
#import <MediaManagement/MMPlaylist.h>

#import "MainViewController_iPad.h"

#import "MMServer.h"
#import "MMRemoteLibrary.h"
#import "MMRemotePlaylist.h"

#import "EditController.h"
#import "ContentTableViewController.h"

@interface MainViewController_iPad(private)
- (void) initialize;
- (NSArray*) playlistListForIndex: (NSInteger) index;
- (NSArray*) playlistListForIndexPath: (NSIndexPath*) indexPath;
- (MMPlaylist*) playlistForIndexPath: (NSIndexPath*) indexPath;


@end

@implementation MainViewController_iPad

- (void) dealloc
{
  [server release];
  [super dealloc];
}

@synthesize server;

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
  MMPlaylist *playlist = [self playlistForIndexPath: indexPath];
  [playlist loadWithBlock:^(void) {
    contentController.playlist = playlist;
    [contentController refresh];
  }];
  // TODO: update
//  contentController.query = query;
//  void (^callback)(void) = ^{
//    [contentController refresh];
//  };
//  [query reloadWithBlock:callback];
}

#pragma mark - Action handlers
- (IBAction) editPressed: (id) sender
{
  NSString *nibName = @"EditController";
  EditController *editController = [[EditController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
  [editController setModalPresentationStyle:UIModalPresentationFormSheet];
  [self presentModalViewController:editController animated:TRUE];
  [editController release];
}

@end
 