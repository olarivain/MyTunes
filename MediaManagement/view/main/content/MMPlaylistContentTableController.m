//
//  ContentViewTableViewController.m
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <KraCommons/KCNibUtils.h>
#import <KraCommons/NSArray+BoundSafe.h>
#import <KraCommons/NSIndexPath+Key.h>

#import <MediaManagement/MMPlaylist.h>
#import <MediaManagement/MMContentList.h>
#import <MediaManagement/MMContent.h>

#import "MMRemoteLibrary.h"
#import "MMRemotePlaylist.h"

#import "MMPlaylistContentTableController.h"

#import "MMPlaylistSubcontentSelector.h"
#import "MMPlaylistContentCell.h"
#import "MMPlaylistContentCellSize.h"
#import "MMContentView.h"

#import "MMEditController_iPad.h"


@interface MMPlaylistContentTableController()
- (void) reload;
- (void) playlistDidLoad;
@end

@implementation MMPlaylistContentTableController

- (void) awakeFromNib
{
  cellSizes = [NSMutableDictionary dictionaryWithCapacity: 2500];
}

@synthesize selectedContentGroup;
@synthesize selectedItem;
@synthesize playlist;

- (void) setPlaylist:(MMPlaylist *) aPlaylist
{
  if(playlist == aPlaylist)
  {
    return;
  }
  
  playlist = aPlaylist;
  subcontentSelector.contentGroups = playlist.contentGroups;
  selectedContentGroup = subcontentSelector.selectedContentGroup;
}

#pragma mark - Loading content
- (void) refresh
{
  // update UI
  loading = YES;
  [contentView setLoading: YES];
  
  // clear table
  [self reload];
  
  // refresh content on callback
  MMPlaylistCallback callback = ^{
    [self playlistDidLoad];
  };
  
  // load playlist
  [playlist loadWithBlock: callback];
}

- (void) playlistDidLoad
{
  // update UI
  loading = NO;
  [contentView setLoading: NO];
  
  // and reload table
  [self reload];
}

- (void) reload
{
  [cellSizes removeAllObjects];
  selectedItem = nil;
  
  [table reloadData];
  
  // scroll back to top, take care to avoid stupid exceptions
  [table setContentOffset: CGPointZero animated: YES];
}

#pragma mark - User Interaction
- (IBAction) refreshAction:(id)sender
{
  [self refresh];
}

#pragma mark - TableData source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  if(loading)
  {
    return 0;
  }
  
  return [selectedContentGroup contentListCount];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  MMContentList *list = [selectedContentGroup contentListForFlatIndex: section];
  return list.name;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if(loading)
  {
    return 0;
  }
  
  MMContentList *list = [selectedContentGroup contentListForFlatIndex: section];
  return [[list content] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"contentCell";
  
  MMPlaylistContentCell *cell = (MMPlaylistContentCell *) [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
  if (cell == nil) {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *nibName = [KCNibUtils nibName: @"MMPlaylistContentCell"];
    [bundle loadNibNamed: nibName owner: self options: nil];
    cell = contentCell;
    contentCell = nil;
  }
  
  MMContentList *contentList = [selectedContentGroup contentListForFlatIndex: indexPath.section];
  MMContent *content = [contentList.content boundSafeObjectAtIndex: indexPath.row];
  MMPlaylistContentCellSize *size = [cellSizes objectForKey: indexPath.key];
  [cell updateWithContent: content withCellSize: size];
    
  return cell;
}

#pragma mark - table delegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  MMPlaylistContentCellSize *size = [cellSizes objectForKey: indexPath.key];
  if(size != nil)
  {
    return size.totalHeight;
  }
  
  // loading sizing cell if not already done  
  if(sizingContentCell == nil)
  {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *nibName = [KCNibUtils nibName: @"MMPlaylistContentCell"];
    [bundle loadNibNamed: nibName owner: self options: nil];
    sizingContentCell = contentCell;
    contentCell = nil;

  }
  
  [sizingContentCell updateSizeWithWidth: tableView.frame.size.width];
  
  // now, size it
  MMContentList *contentList = [selectedContentGroup contentListForFlatIndex: indexPath.section];
  MMContent *content = [contentList.content boundSafeObjectAtIndex: indexPath.row];
  size = [sizingContentCell sizeForContent: content];
  
  // cache it
  [cellSizes setObject: size forKey: indexPath.key];
  return size.totalHeight;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  MMContentList *contentList = [selectedContentGroup contentListForFlatIndex: indexPath.section];  
  MMContent *content = [[contentList content] objectAtIndex: indexPath.row];
  selectedItem = content;
  
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
  
  // grab a handle on the next view controller
  NSString *nibName = [KCNibUtils nibName: @"MMEditController"];
  MMEditController_iPad *editController = [[MMEditController_iPad alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
  editController.currentItem = selectedItem;
  editController.contentGroup = selectedContentGroup;
  editController.playlist = playlist;
  editController.delegate = self;
  
  // and present it in a form sheet
  [editController setModalPresentationStyle: UIModalPresentationFormSheet];
  [controller presentModalViewController:editController animated:TRUE];
}

#pragma mark - edit controller delegate
- (void) didEditContent:(MMContent *)item 
{
  // ask library to update shit and refresh
  [playlist.library updateContent: item];
  [self refresh];
}

#pragma mark - Changing Content Group
- (IBAction) didSelectPlaylistContentType: (id) sender
{
  selectedContentGroup = [subcontentSelector selectedContentGroup];
  [self refresh];
}

@end
