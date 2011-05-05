//
//  MainViewController_iPad.m
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MainViewController_iPad.h"

#import "MMServer.h"
#import "EditController.h"

#import "MMQueryGroup.h"
#import "MMQuery.h"

@interface MainViewController_iPad(private)
- (void) initialize;
- (MMQueryGroup*) queryGroupForIndex: (NSUInteger) index;
- (MMQueryGroup*) queryGroupForIndexPath: (NSIndexPath*) indexPath;
- (MMQuery*) queryForIndexPath: (NSIndexPath*) indexPath;
@end

@implementation MainViewController_iPad

- (void) dealloc
{
  [server release];
  [super dealloc];
}

@synthesize server;

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void) viewDidLoad
{
  [super viewDidLoad];
  [[self navigationItem] setTitle: [server name]];
  
}
- (void)viewDidUnload
{
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return YES;
}

#pragma mark - TableView Data source
#pragma Convienence accessors
- (MMQueryGroup*) queryGroupForIndex: (NSUInteger) index
{
  MMQueryGroup *group = [[server queryGroups] objectAtIndex: index];
  return group;
}

- (MMQueryGroup*) queryGroupForIndexPath: (NSIndexPath*) indexPath
{
  return [self queryGroupForIndex: indexPath.section];
}

- (MMQuery*) queryForIndexPath: (NSIndexPath*) indexPath
{
  MMQueryGroup *group = [self queryGroupForIndexPath: indexPath];
  MMQuery *query = [[group queries] objectAtIndex: indexPath.row];
  return query;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
  return [[server queryGroups] count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  MMQueryGroup *group = [self queryGroupForIndex: section];
  return [group queryCount];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  MMQuery *query = [self queryForIndexPath: indexPath];
  
  NSString *cellId = @"queryCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellId];
  if(cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellId];
  }
  
  cell.textLabel.text = query.name;
  return cell;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  MMQueryGroup *group = [self queryGroupForIndex: section];
  return group.name;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
  
  MMQuery *query = [self queryForIndexPath: indexPath];
  void (^callback)(void) = ^{
    // 
  };
  [query reloadWithBlock:callback];
}

#pragma mark - Action handlers
- (IBAction) editPressed: (id) sender
{
  NSString *nibName = @"EditController";
  EditController *editController = [[EditController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
  [editController setModalPresentationStyle:UIModalPresentationFormSheet];
  [self presentModalViewController:editController animated:TRUE];
  [editController release];
}

@end
