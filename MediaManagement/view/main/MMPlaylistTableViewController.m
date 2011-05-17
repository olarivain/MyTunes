//
//  ContentViewTableViewController.m
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//


#import <MediaManagement/MMContentList.h>
#import <MediaManagement/MMContent.h>

#import "MMPlaylistTableViewController.h"

@implementation MMPlaylistTableViewController

- (void)dealloc
{
  [super dealloc];
}

@synthesize table;
@synthesize selectedContentGroup;

#pragma mark - Table view data source
- (void) refresh
{
  [table reloadData];
}

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
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  
  MMContentList *contentList = [selectedContentGroup contentListForFlatIndex: indexPath.section];
  
  MMContent *content = [[contentList content] objectAtIndex: indexPath.row];
  cell.textLabel.text = content.name;
    
  return cell;
}

@end
