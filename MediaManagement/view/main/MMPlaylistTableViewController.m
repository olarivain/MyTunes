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

#import "MMPlaylistTableViewController.h"

@implementation MMPlaylistTableViewController

- (void)dealloc
{
  self.playlist = nil;
  [super dealloc];
}

@synthesize table;
@synthesize playlist;
@synthesize selectedContentType;

#pragma mark - Table view data source
- (void) refresh
{
  [table reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  NSArray *contentLists = [playlist contentListsWithSubContentType: selectedContentType];
  return [contentLists count];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  NSArray *contentLists = [playlist contentListsWithSubContentType: selectedContentType];
  MMContentList *contentList = [contentLists objectAtIndex: section];
  return contentList.name;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSArray *contentLists = [playlist contentListsWithSubContentType: selectedContentType];
  MMContentList *contentList = [contentLists objectAtIndex: section];
  return [[contentList content] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *CellIdentifier = @"TrackCell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  
  NSArray *contentLists = [playlist contentListsWithSubContentType: selectedContentType];
  MMContentList *contentList = [contentLists objectAtIndex: indexPath.section];
  MMContent *content = [[contentList content] objectAtIndex: indexPath.row];
  cell.textLabel.text = content.name;
    
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
