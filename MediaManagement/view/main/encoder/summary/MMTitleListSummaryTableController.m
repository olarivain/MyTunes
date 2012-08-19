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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return YES if you want the specified item to be editable.
  return YES;
}

#pragma mark - deleting titles
- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
  // we don't support anything else than delete
  if(editingStyle != UITableViewCellEditingStyleDelete)
  {
    return;
  }
  
  // prompt for confirmation first, this will just DELETE, no recovery.
  titlePendingDelete = [encoder.availableResources boundSafeObjectAtIndex: indexPath.row];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle: [NSString stringWithFormat: @"Delete %@", titlePendingDelete.name]
                                                  message: @"Once deleted, this resource won't be accessible anymore"
                                                 delegate: self
                                        cancelButtonTitle: @"Cancel"
                                        otherButtonTitles: @"Delete", nil];
  [alert show];
}

- (void) didDeleteTitleList: (NSError *) error {
  // update UI
  loadingView.hidden = YES;
  [self refresh];
  
  // no error, we're done here
  if(!error) {
    return;
  }
  
  // otherwise, prompt the user with the error
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error"
                                                  message: error.localizedDescription
                                                 delegate: nil
                                        cancelButtonTitle: @"OK"
                                        otherButtonTitles: nil];
  [alert show];
}

#pragma mark - alert view delegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if(buttonIndex == alertView.cancelButtonIndex) {
    titlePendingDelete = nil;
    return;
  }
  
  loadingView.hidden = NO;
  MMRemoteEncoderErrorCallback callback = ^(NSError * error) {
    [self didDeleteTitleList: error];
  };
  [encoder deleteTitleList: titlePendingDelete
              withCallback: callback];
  titlePendingDelete = nil;
}

@end
