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

#import "MMPlaylistContentTableController.h"

#import "MMPlaylistSubcontentSelector.h"
#import "MMPlaylistContentCell.h"
#import "MMPlaylistContentCellSize.h"

#import "MMEditController_iPad.h"


@interface MMPlaylistContentTableController()
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

#pragma mark - Table view data source
- (void) refresh
{
  [cellSizes removeAllObjects];
  selectedItem = nil;
  editButton.enabled = NO;
  
  [table reloadData];
  // scroll back to top, take care to avoid stupid exceptions
  if([table numberOfSections] > 0 && [table numberOfRowsInSection: 0] > 0) 
  {
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [table scrollToRowAtIndexPath:path atScrollPosition: UITableViewScrollPositionTop animated: NO];
  }
}

#pragma mark - TableData source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [selectedContentGroup contentListCount];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  MMContentList *list = [selectedContentGroup contentListForFlatIndex: section];
  return list.name;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
