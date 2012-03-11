//
//  MMEncoderTableController.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/30/11.
//  Copyright (c) 2011 kra. All rights reserved.
//

#import <KraCommons/NSArray+BoundSafe.h>
#import <KraCommons/KCNibUtils.h>
#import <MediaManagement/MMTitleList.h>

#import "MMTitleListSummaryTableController.h"

#import "MMRemoteEncoder.h"

#import "MMTitleListDetailViewController.h"
#import "MMTitleListSummaryCell.h"
#import "MMContentView.h"

@interface MMTitleListSummaryTableController()

- (void) reload;
- (void) didLoadEncoder;

@end

@implementation MMTitleListSummaryTableController

@synthesize encoder;

#pragma mark - Reloading content
- (void) refresh
{
  [contentView setLoading: TRUE];

  MMRemoteEncoderCallback callback = ^{
    [self didLoadEncoder];
  };
  
  [encoder loadAvailableResources: callback];
}

- (void) didLoadEncoder
{
  [contentView setLoading: NO];
  [self reload];
}

- (void) reload
{
  [table reloadData];
  [table setContentOffset: CGPointZero animated: YES];
}

#pragma mark - User Action
- (IBAction) refreshAction:(id)sender
{
  [self refresh];
}


#pragma mark - Table Data Source
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
  MMTitleListSummaryCell *cell = (MMTitleListSummaryCell *) [tableView dequeueReusableCellWithIdentifier: cellId];
  if(cell == nil)
  {
    NSString *nibName = [KCNibUtils nibName: @"MMTitleListSummaryCell"] ;
    NSBundle *bundle = [NSBundle mainBundle];
    [bundle loadNibNamed: nibName owner: self options: nil];
    cell = resourceCell;
    resourceCell = nil;
  }
  
  MMTitleList *titleList = [encoder.availableResources boundSafeObjectAtIndex: indexPath.row];
  [cell updateWithTitleList: titleList];
  return cell;
}

#pragma mark - Table delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // load nib for edit view
  MMTitleListDetailViewController *detailController = [[MMTitleListDetailViewController alloc] initWithNibName:@"MMTitleListDetailViewController" bundle: [NSBundle mainBundle]];
  detailController.encoder = encoder;
  detailController.titleList = [encoder.availableResources boundSafeObjectAtIndex: indexPath.row];
  [detailController setModalPresentationStyle: UIModalPresentationFormSheet];
  
  [controller presentModalViewController: detailController animated: YES];
  
  // and deselect row
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

@end
