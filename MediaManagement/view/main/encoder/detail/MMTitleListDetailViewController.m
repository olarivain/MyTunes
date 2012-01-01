//
//  MMTitleListViewController.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 Edmunds. All rights reserved.
//

#import <KraCommons/KCNibUtils.h>
#import <KraCommons/NSArray+BoundSafe.h>
#import <MediaManagement/MMTitleList.h>

#import "MMTitleListDetailViewController.h"

#import "MMRemoteEncoder.h"

#import "MMLoadingView.h"
#import "MMTitleDetailCell.h"

@interface MMTitleListDetailViewController()
- (void) updateContent;
- (void) didScanResource;
@end

@implementation MMTitleListDetailViewController

@synthesize encoder;
@synthesize titleList;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  table.rowHeight = 159;
  [self updateContent];
  // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
  table = nil;
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Loading content
- (void) updateContent
{
  MMRemoteEncoderCallback callback = ^{
    [self didScanResource];
  };
  [encoder scanResource: titleList andCallback: callback];
  [loadingView setLoading: YES];
}

- (void) didScanResource
{
  [loadingView setLoading: NO];
  [table reloadData];
}

#pragma mark - Table Data Source
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [titleList.titles count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellId = @"titleCell";
  MMTitleDetailCell *cell = (MMTitleDetailCell *) [tableView dequeueReusableCellWithIdentifier: cellId];
  if(cell == nil)
  {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *nibName = [KCNibUtils nibName: @"MMTitleDetailCell"];
    
    [bundle loadNibNamed: nibName owner: self options: nil];
    cell = titleCell;
    titleCell = nil;
  }
  
  MMTitle *title = [titleList.titles boundSafeObjectAtIndex: indexPath.row];
  [cell updateWithTitle: title];
  
  return cell;
}

#pragma mark - User Actions
- (IBAction) cancel:(id)sender
{
  [self.presentingViewController dismissModalViewControllerAnimated: YES];
}

- (IBAction) schedule:(id)sender
{
  [self.presentingViewController dismissModalViewControllerAnimated: YES];
}
@end
