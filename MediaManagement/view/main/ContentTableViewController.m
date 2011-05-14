//
//  ContentViewTableViewController.m
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "ContentTableViewController.h"

#import "MMQuery.h"
#import "MMMusicPlaylist.h"
#import "MMMoviesPlaylist.h"
#import "MMArtist.h"
#import "MMAlbum.h"

@implementation ContentTableViewController

- (void)dealloc
{
  self.query = nil;
  [super dealloc];
}

@synthesize table;
@synthesize query;

#pragma mark - Table view data source
- (void) refresh
{
  [table reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  
  MMPlaylist *library = query.library;
  NSInteger sections = [library sectionsCount];
  return sections;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return [query.library titleForSection: section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  MMPlaylist *library = query.library;
  if(![library isKindOfClass: [MMMusicPlaylist class]])
  {
    return  [library.content count];
  }
  
  NSInteger count = 0;
  MMMusicPlaylist *music = (MMMusicPlaylist*) library;
  MMArtist *artist = [music.artists objectAtIndex: section];
  for(MMAlbum *album in artist.albums)
  {
    count += [album.tracks count];
  }
  return  count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *CellIdentifier = @"TrackCell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  
  MMContent *content = nil;
  MMPlaylist *library = query.library;
  if(![library isKindOfClass: [MMMusicPlaylist class]])
  {
    content = [library.content objectAtIndex: indexPath.row];
  } 
  else
  {
    MMMusicPlaylist *music = (MMMusicPlaylist*) library;
    MMArtist *artist = [music.artists objectAtIndex: indexPath.section];
    NSInteger count = 0;
    for(MMAlbum *album in artist.albums)
    {
      for(MMContent *track in album.tracks)
      {
         if(indexPath.row == count)
         {
           content = track;
           break;
         }
        count++;
      }
      if(content != nil)
      {
        break;
      }
    }
  }
    
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
