//
//  ContentViewTableViewController.m
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//


#import <MediaManagement/MMPlaylist.h>
#import <MediaManagement/MMContentList.h>
#import <MediaManagement/MMContent.h>

#import "MMPlaylistContentTableController.h"
#import "MMPlaylistSubcontentSelector.h"


@interface MMPlaylistContentTableController()
@end

@implementation MMPlaylistContentTableController


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
  NSString *CellIdentifier = @"TrackCell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  MMContentList *contentList = [selectedContentGroup contentListForFlatIndex: indexPath.section];
  
  MMContent *content = [[contentList content] objectAtIndex: indexPath.row];
  cell.textLabel.text = content.name;
    
  return cell;
}

#pragma mark - table delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  MMContentList *contentList = [selectedContentGroup contentListForFlatIndex: indexPath.section];  
  MMContent *content = [[contentList content] objectAtIndex: indexPath.row];
  editButton.enabled = YES;
  selectedItem = content;
}

#pragma mark - Changing Content Group
- (IBAction) didSelectPlaylistContentType: (id) sender
{
  selectedContentGroup = [subcontentSelector selectedContentGroup];
  [self refresh];
}

@end