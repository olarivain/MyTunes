//
//  MMEncoderTableController.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/30/11.
//  Copyright (c) 2011 Edmunds. All rights reserved.
//

#import <KraCommons/NSArray+BoundSafe.h>
#import <KraCommons/KCNibUtils.h>
#import <MediaManagement/MMTitleList.h>

#import "MMEncoderTableController.h"

#import "MMRemoteEncoder.h"

#import "MMEncoderResourceCell.h"

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
  MMEncoderResourceCell *cell = (MMEncoderResourceCell *) [tableView dequeueReusableCellWithIdentifier: cellId];
  if(cell == nil)
  {
    NSString *nibName = [KCNibUtils nibName: @"MMEncoderResourceCell"] ;
    NSBundle *bundle = [NSBundle mainBundle];
    [bundle loadNibNamed: nibName owner: self options: nil];
    cell = resourceCell;
    resourceCell = nil;
  }
  
  MMTitleList *titleList = [encoder.availableResources boundSafeObjectAtIndex: indexPath.row];
  [cell updateWithTitleList: titleList];
  return cell;
}

@end
