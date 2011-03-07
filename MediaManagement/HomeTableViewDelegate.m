//
//  HomeTableController.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeTableViewDelegate.h"
#import "Servers.h"
#import "Server.h"

@implementation HomeTableViewDelegate

- (id) init
{
  self = [super init];
  if(self)
  {
    servers = [[Servers alloc] init];
    [servers setDelegate: self];
  }
  
  return self;
}

- (void) dealloc
{
  [servers release];
  [super dealloc];
}

#pragma mark - Business methods
- (void) refresh
{
  [servers refreshServerList];
}

#pragma mark - UITableViewDelegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [[servers servers] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  Server *server = [servers serverAtIndexPath: indexPath];
  NSString *cellIdentifier = [server hostname];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
  if(cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
    [[cell textLabel] setBackgroundColor: [UIColor clearColor]];
    [[cell textLabel] setTextColor: [UIColor whiteColor]];
    [[cell textLabel] setTextAlignment: UITextAlignmentCenter];
  }
  
  [[cell textLabel] setText: [server name]];
  return cell;
}

#pragma mark - ServersDelegate methods
- (void) didRefresh:(Servers *)sender
{
  [table reloadData];
}

- (void) didNotRefresh:(Servers *)sender
{
  NSLog(@"Could not refresh...");
}


@end
