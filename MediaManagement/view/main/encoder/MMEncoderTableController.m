//
//  MMEncoderTableController.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/30/11.
//  Copyright (c) 2011 Edmunds. All rights reserved.
//

#import <KraCommons/NSArray+BoundSafe.h>
#import <MediaManagement/MMTitleList.h>
#import "MMEncoderTableController.h"

#import "MMRemoteEncoder.h"

@implementation MMEncoderTableController

@synthesize encoder;

- (void) refresh
{
  [table reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [encoder.availableResources count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *cellId = @"encoderResource";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellId];
  if(cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellId];
  }
  
  MMTitleList *titleList = [encoder.availableResources boundSafeObjectAtIndex: indexPath.row];
  cell.textLabel.text = titleList.name;
  return cell;
}

@end
