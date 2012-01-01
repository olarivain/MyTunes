//
//  MMAudioTrackTableController.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 Edmunds. All rights reserved.
//

#import <KraCommons/NSArray+BoundSafe.h>

#import "MMAudioTrackTableController.h"

#import "MMAudioTrackCell.h"

#define HEADER_HEIGHT 22

@implementation MMAudioTrackTableController

@synthesize audioTracks;

- (void) refresh
{
  [table reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  NSInteger count = [audioTracks count];
  NSString *countString = count == 0 ? @"No Audio Track" : [NSString stringWithFormat: @"%i Audio Tracks", count];
  return countString;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [audioTracks count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
  
  MMAudioTrack *track = [audioTracks boundSafeObjectAtIndex: indexPath.row];
  [cell updateWithAudioTrack: track];
  
  BOOL hidesSeparator = (indexPath.row + 1) == [audioTracks count];
  [cell hidesSeparator: hidesSeparator];
  
  return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(sizingAudioCell == nil)
  {
    NSBundle *bundle = [NSBundle mainBundle];
    [bundle loadNibNamed: @"MMAudioTrackCell" owner: self options: nil];
    sizingAudioCell = audioCell;
    audioCell = nil;
  }
  return sizingAudioCell.frame.size.height;
}


- (CGFloat) totalHeightForTracks: (NSArray *) tracks
{
  if(sizingAudioCell == nil)
  {
    NSBundle *bundle = [NSBundle mainBundle];
    [bundle loadNibNamed: @"MMAudioTrackCell" owner: self options: nil];
    sizingAudioCell = audioCell;
    audioCell = nil;
  }
  
  return sizingAudioCell.frame.size.height * [tracks count] + HEADER_HEIGHT;
}

@end