//
//  MMPlaylistTableController.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/30/11.
//  Copyright (c) 2011 Edmunds. All rights reserved.
//

#import <KraCommons/NSArray+BoundSafe.h>
#import <MediaManagement/MMPlaylist.h>

#import "MMLibraryNavigationTableController.h"

#import "MMRemoteLibrary.h"

@interface MMLibraryNavigationTableController()
// playlist convenience accessors
- (NSArray*) playlistListForSection: (NSInteger) section;
- (MMPlaylist*) playlistForIndexPath: (NSIndexPath*) indexPath;
- (NSIndexPath *) indexPathForPlaylist: (MMPlaylist *) playlist;

// determining if an indexpath/section is for a playlist
- (BOOL) isPlaylistAtIndexPath: (NSIndexPath *) indexPath;
- (BOOL) isPlaylistAtSection: (NSInteger) section;

// build cells
- (UITableViewCell *) tableView:(UITableView *)tableView playlistCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *) tableView:(UITableView *)tableView encoderCellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MMLibraryNavigationTableController

@synthesize library;

- (void) selectPlaylist: (MMPlaylist *) playlist
{
  if(playlist == nil)
  {
    NSIndexPath *path = [NSIndexPath indexPathForRow: 0 inSection: 0];
    playlist = [self playlistForIndexPath: path];
  }
  
  // plauylist doesn't exist, get the hell out
  if(playlist == nil)
  {
    return;
  }
  
  // select it in the table
  NSIndexPath *selectedIndexPath = [self indexPathForPlaylist: playlist];
  [table selectRowAtIndexPath: selectedIndexPath animated: NO scrollPosition:UITableViewScrollPositionTop];
  
  // and notify delegate it has been selected
  [delegate didSelectPlaylist: playlist];
}

#pragma mark - TableView Data source
#pragma mark Section/Rows count
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
  // library + encoder are ALWAYS there.
  // don't display user playlists if there not available
  return 2 + [library hasUserPlaylist];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if([self isPlaylistAtSection: section])
  {
    NSArray *playlists = [self playlistListForSection: section];
    return [playlists count];
  }
  
  return 2;
}

#pragma mark Build Cells
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if([self isPlaylistAtIndexPath: indexPath])
  {
    return [self tableView: tableView playlistCellForRowAtIndexPath: indexPath];
  }
  
  return [self tableView: tableView encoderCellForRowAtIndexPath: indexPath];
}

#pragma mark Playlist cells
- (UITableViewCell *) tableView:(UITableView *)tableView playlistCellForRowAtIndexPath:(NSIndexPath *)indexPath
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

#pragma mark Encoder cells
- (UITableViewCell *) tableView:(UITableView *)tableView encoderCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *cellId = @"encoderCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellId];
  if(cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellId];
  }
  
  cell.textLabel.text = indexPath.row == 0 ? @"All" : @"In Progress";
  return cell;

}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  // titles for playlists
  if([self isPlaylistAtSection: section])
  {
    return section == 0 ? @"Library" : @"Encoder";
  }
  
  // if we got here, we have no user playlist and we're beyond library: the section is the encoder
  return @"Encoder";
}

#pragma mark - Table Delegate
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{ 
  if([self isPlaylistAtIndexPath: indexPath])
  {
    MMPlaylist *playlist = [self playlistForIndexPath: indexPath];
    [delegate didSelectPlaylist: playlist];
    return;
  }
  
  if(indexPath.row == 0)
  {
    [delegate didSelectEncoderResources];
    return;
  }
  [delegate didSelectPendingEncodings];
}

#pragma - Plaulist from index paths/sections
- (NSArray*) playlistListForSection: (NSInteger) index
{
  NSArray *playlists = index == 0 ? library.systemPlaylists : library.userPlaylists;
  return playlists;
}

- (MMPlaylist*) playlistForIndexPath: (NSIndexPath*) indexPath
{
  NSArray *playlists = [self playlistListForSection: indexPath.section];
  MMPlaylist *playlist = [playlists boundSafeObjectAtIndex: indexPath.row];
  return playlist;
}
                                    
- (NSIndexPath *) indexPathForPlaylist: (MMPlaylist *) playlist
{
  NSArray *container = library.systemPlaylists;
  NSInteger section = 0;
  if([library.userPlaylists containsObject:playlist])
  {
    section = 1;
    container = library.userPlaylists;
  }
  
  NSInteger row = [container indexOfObject: playlist];
  return [NSIndexPath indexPathForRow: row inSection: section];
}

#pragma mark - whether an index path represents a playlist or the encoder's sections
- (BOOL) isPlaylistAtIndexPath: (NSIndexPath *) indexPath
{
  return [self isPlaylistAtSection: indexPath.section];
}
      
- (BOOL) isPlaylistAtSection: (NSInteger) section
{
  return section == 0 || (section == 1 && [library hasUserPlaylist]);
}
  

@end
