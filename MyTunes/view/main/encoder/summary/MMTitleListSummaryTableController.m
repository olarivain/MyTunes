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

#define SINGLE_DELETE_ALERT_TAG 1
#define BATCH_DELETE_ALERT_TAG 2


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

- (IBAction) editAction: (id)sender
{
	BOOL wasEditing = table.editing;
	// if we weren't editing, set the table in edit mode
	if(!wasEditing) {
		// first, flip the switch here
		[table setEditing: YES
				 animated: YES];
		titlesPendingBatchDelete = [NSMutableArray arrayWithCapacity: 10];
		// update the buttons
		[self updateEditButtons];
	}
	
	// commit the delete if the user pressed done
	if(wasEditing)
	{
		[self batchDeleteItems];
	}
}

- (void) updateEditButtons
{
	cancelEditButton.enabled = table.editing;
	editButton.title = table.editing ? @"Done" : @"Edit";
}

- (IBAction) cancelEditAction:(id)sender
{
	[table setEditing: NO
			 animated: YES];
	
	// update the buttons
	[self updateEditButtons];
	
	titlesPendingBatchDelete = nil;
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
	// add the title to the pending list if we're editing the table
	if([tableView isEditing]) {
		MMTitleList *titleList = [encoder.availableResources boundSafeObjectAtIndex: indexPath.row];
		[titlesPendingBatchDelete addObjectNilSafe: titleList];
		return;
	}
	
	// load nib for edit view
	MMTitleListDetailViewController *detailController = [[MMTitleListDetailViewController alloc] initWithNibName:@"MMTitleListDetailViewController" bundle: [NSBundle mainBundle]];
	detailController.encoder = encoder;
	detailController.titleList = [encoder.availableResources boundSafeObjectAtIndex: indexPath.row];
	[detailController setModalPresentationStyle: UIModalPresentationFormSheet];
	
	[controller presentModalViewController: detailController animated: YES];
	
	// and deselect row
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	// we don't care about deselect when not editing
	if(!table.editing)
	{
		return;
	}
	
	// otherwise, remove the item from the list
	MMTitleList *titleList = [encoder.availableResources boundSafeObjectAtIndex: indexPath.row];
	[titlesPendingBatchDelete removeObject: titleList];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return YES if you want the specified item to be editable.
	return YES;
}

#pragma mark - deleting titles
#pragma mark Single delete
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
	alert.tag = SINGLE_DELETE_ALERT_TAG;
	[alert show];
}

- (void) confirmedSingleDelete
{
	[contentView setLoading: YES];
	
	MMRemoteEncoderErrorCallback callback = ^(NSError * error) {
		[self didDeleteTitleList: error];
	};
	[encoder deleteTitleList: titlePendingDelete
				withCallback: callback];
	titlesPendingBatchDelete = nil;
	titlePendingDelete = nil;
}

- (void) didDeleteTitleList: (NSError *) error {
	// update UI
	[contentView setLoading: NO];
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

#pragma mark - Bulk deletes
- (void) batchDeleteItems
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Delete selected resources?"
													message: @"Once deleted, these resources won't be accessible anymore"
												   delegate: self
										  cancelButtonTitle: @"Cancel"
										  otherButtonTitles: @"Delete", nil];
	alert.tag = BATCH_DELETE_ALERT_TAG;
	[alert show];
	
}

- (void) confirmedBatchDelete
{
	[table setEditing: NO
			 animated: YES];
	
	// update the buttons
	[self updateEditButtons];
	
	[contentView setLoading: YES];
	
	__block NSInteger count = titlesPendingBatchDelete.count;
	__block BOOL hasError = NO;
	
	for(MMTitleList *titleList in titlesPendingBatchDelete)
	{
		MMRemoteEncoderErrorCallback callback = ^(NSError * error) {
			@synchronized(self)
			{
				hasError |= error != nil;
				
				count--;
				if(count > 0)
				{
					return ;
				}
			}
			[self didBatchDeleteTitleList: hasError];
		};
		[encoder deleteTitleList: titleList
					withCallback: callback];
		
	}
}

- (void) didBatchDeleteTitleList: (BOOL) hasError {
	// update UI
	[contentView setLoading: NO];
	[self refresh];
	titlesPendingBatchDelete = nil;
	titlePendingDelete = nil;
	
	// no error, we're done here
	if(!hasError) {
		return;
	}
	
	// otherwise, prompt the user with the error
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error"
													message: @"Some resources could not be deleted"
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
	
	
	switch (alertView.tag) {
		case SINGLE_DELETE_ALERT_TAG:
			[self confirmedSingleDelete];
			break;
		case BATCH_DELETE_ALERT_TAG:
			[self confirmedBatchDelete];
		default:
			break;
	}
}

@end
