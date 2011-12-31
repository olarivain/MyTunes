//
//  MMPlaylistTableController.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/30/11.
//  Copyright (c) 2011 Edmunds. All rights reserved.
//

#import <MediaManagement/MMPlaylist.h>

#import "MMPlaylistTableController.h"

#import "MMRemoteLibrary.h"

@interface MMPlaylistTableController()
- (NSArray*) playlistListForIndex: (NSInteger) index;
- (NSArray*) playlistListForIndexPath: (NSIndexPath*) indexPath;
- (MMPlaylist*) playlistForIndexPath: (NSIndexPath*) indexPath;
@end

@implementation MMPlaylistTableController

@synthesize library;

- (void) selectFirstPlaylist
{
  NSIndexPath *path = [NSIndexPath indexPathForRow: 0 inSection: 0];
  MMPlaylist *firstPlaylist = [self playlistForIndexPath: path];
  // plauylist doesn't exist, get the hell out
  if(firstPlaylist == nil)
  {
    return;
  }
  
  // select it in the table
  [table selectRowAtIndexPath: path animated: NO scrollPosition:UITableViewScrollPositionTop];
  
  // and notify delegate it has been selected
  [delegate didSelectPlaylist: firstPlaylist];
}

#pragma mark - TableView Data source
#pragma Convienence accessors
- (NSArray*) playlistListForIndex: (NSInteger) index
{
  return [self playlistListForIndexPath: [NSIndexPath indexPathForRow: 0 inSection: index]];
}

- (NSArray*) playlistListForIndexPath: (NSIndexPath*) indexPath
{
  
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
  // library + encoder are ALWAYS there.
  // don't display user playlists if there not available
  return 2 + [library hasUserPlaylist];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSArray *playlists = [self playlistListForIndex: section];
  return [playlists count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *cellId = @"playlistCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellId];
  if(cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellId];
  }
  
  MMPlaylist *playlist = [self playlistForIndexPath: indexPath];
  cell.textLabel.text = playlist.name;
  return cell;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  // library is always first
  if(section == 0)
  {
    return @"Library";
  }
  
  // we have a playlist, return appropriate title
  if([library hasUserPlaylist])
  {
    return section == 1 ? @"Playlists" : @"Encoder";
  }
  
  // if we got here, we have no user playlist and we're beyond library: the section is the encoder
  return @"Encoder";
}

#pragma mark - Table Delegate
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{ 
  MMPlaylist *playlist = [self playlistForIndexPath: indexPath];
  [delegate didSelectPlaylist: playlist];
}

@end
