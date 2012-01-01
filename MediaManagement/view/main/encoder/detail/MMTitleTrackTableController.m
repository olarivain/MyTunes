//
//  MMAudioTrackTableController.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 Edmunds. All rights reserved.
//

#import <KraCommons/NSArray+BoundSafe.h>
#import <MediaManagement/MMTitle.h>

#import "MMTitleTrackTableController.h"

#import "MMAudioTrackCell.h"
#import "MMSubtitleTrackCell.h"
#import "MMTitleTrackSectionHeader.h"

#define HEADER_HEIGHT 35

@interface MMTitleTrackTableController()
- (void) loadSizingCells;
- (UITableViewCell *) tableView: (UITableView *) tableView audioCellForRowAtIndexPath: (NSIndexPath *) indexPath;
- (UITableViewCell *) tableView: (UITableView *) tableView subtitleCellForRowAtIndexPath: (NSIndexPath *) indexPath;
@end

@implementation MMTitleTrackTableController

@synthesize title;

- (void) refresh
{
  [table reloadData];
}

#pragma mark - Table Data source
#pragma mark row/section counts
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if(section == 0)
  {
    return [title.audioTracks count];
  }
  return [title.subtitleTracks count];
}

#pragma mark section header creation
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  // audio first
  if(section == 0)
  {
    NSInteger count = [title.audioTracks count];
    NSString *tracks = count > 1 ? @"Tracks" : @"Track";
    NSString *countString = count == 0 ? @"No Audio Track" : [NSString stringWithFormat: @"%i Audio %@", count, tracks];
    return countString;
  }
  // then subtitles
  NSInteger count = [title.subtitleTracks count];
  NSString *tracks = count > 1 ? @"Tracks" : @"Track";
  NSString *countString = count == 0 ? @"No Subtitle Track" : [NSString stringWithFormat: @"%i Subtitle %@", count, tracks];
  return countString;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  // create header, size doesn't matter here, but it can't hurt to set to the right size upfront
  CGRect headerFrame = CGRectMake(0, 0, tableView.frame.size.width, HEADER_HEIGHT);
  MMTitleTrackSectionHeader *header = [[MMTitleTrackSectionHeader alloc] initWithFrame: headerFrame];

  // inject title and return
  NSString *theTitle = [self tableView: tableView titleForHeaderInSection: section];
  [header setTitle: theTitle];
  return header;
}

#pragma mark  Cell creation
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(indexPath.section == 0)
  {
    return [self tableView: tableView audioCellForRowAtIndexPath: indexPath];
  }
  
  return  [self tableView: tableView subtitleCellForRowAtIndexPath: indexPath];
}

#pragma Audio cell creation
- (UITableViewCell *) tableView: (UITableView *) tableView audioCellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *cellId = @"audioTrackCell";
  MMAudioTrackCell *cell = (MMAudioTrackCell *) [tableView dequeueReusableCellWithIdentifier: cellId];
  
  if(cell == nil)
  {
    NSBundle *bundle = [NSBundle mainBundle];
    [bundle loadNibNamed: @"MMAudioTrackCell" owner: self options: nil];
    cell = audioCell;
    audioCell = nil;
  }
  
  MMAudioTrack *track = [title.audioTracks boundSafeObjectAtIndex: indexPath.row];
  [cell updateWithAudioTrack: track];
  
  BOOL hidesSeparator = (indexPath.row + 1) == [title.audioTracks count];
  [cell hidesSeparator: hidesSeparator];
  return cell;
}

#pragma Subtitle cell creation
- (UITableViewCell *) tableView: (UITableView *) tableView subtitleCellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *cellId = @"subtitleTrackCell";
  MMSubtitleTrackCell *cell = (MMSubtitleTrackCell *) [tableView dequeueReusableCellWithIdentifier: cellId];
  
  if(cell == nil)
  {
    NSBundle *bundle = [NSBundle mainBundle];
    [bundle loadNibNamed: @"MMSubtitleTrackCell" owner: self options: nil];
    cell = subtitleCell;
    subtitleCell = nil;
  }
  
  MMSubtitleTrack *track = [title.subtitleTracks boundSafeObjectAtIndex: indexPath.row];
  [cell updateWithSubtitleTrack: track];
  
  BOOL hidesSeparator = (indexPath.row + 1) == [title.subtitleTracks count];
  [cell hidesSeparator: hidesSeparator];
  
  return cell;

}

#pragma mark - Table delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
  
  if(indexPath.section == 0)
  {
    MMAudioTrack *track = [title.audioTracks boundSafeObjectAtIndex: indexPath.row];
    [delegate title:title didSelectAudioTrack: track];
  }
  else
  {
    MMSubtitleTrack *track = [title.subtitleTracks boundSafeObjectAtIndex: indexPath.row];
    [delegate title:title didSelectSubtitleTrack: track];
  }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return HEADER_HEIGHT;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(sizingAudioCell == nil)
  {
    [self loadSizingCells];
  }
  
  return indexPath.section == 0 ? sizingAudioCell.frame.size.height : sizingSubtitleCell.frame.size.height;
}


#pragma mark - Sizing
- (void) loadSizingCells
{
  // load audio and subtitle sizing cells
  NSBundle *bundle = [NSBundle mainBundle];
  [bundle loadNibNamed: @"MMAudioTrackCell" owner: self options: nil];
  sizingAudioCell = audioCell;
  audioCell = nil;
  
  [bundle loadNibNamed: @"MMSubtitleTrackCell" owner: self options: nil];
  sizingSubtitleCell = subtitleCell;
  subtitleCell = nil;
}

- (CGFloat) totalHeightForAudioTracks:(NSArray *)audios andSubtitleTracks:(NSArray *)subtitles
{
  if(sizingAudioCell == nil)
  {
     [self loadSizingCells];
  }
  
  return 2 * HEADER_HEIGHT + sizingAudioCell.frame.size.height * [audios count] + sizingSubtitleCell.frame.size.height * [subtitles count];
}

@end
