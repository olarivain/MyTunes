//
//  MMTitleListViewController.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 Edmunds. All rights reserved.
//

#import <KraCommons/KCNibUtils.h>
#import <KraCommons/NSIndexPath+Key.h>
#import <KraCommons/NSArray+BoundSafe.h>
#import <MediaManagement/MMTitleList.h>
#import <MediaManagement/MMTitle.h>
#import <MediaManagement/MMAudioTrack.h>
#import <MediaManagement/MMSubtitleTrack.h>

#import "MMTitleListDetailViewController.h"

#import "MMRemoteEncoder.h"

#import "MMLoadingView.h"
#import "MMTitleDetailCell.h"
#import "MMTitleDetailCellSize.h"

@interface MMTitleListDetailViewController()
- (void) updateContent;
- (void) didScanResource;
- (void) sharedInit;
@end

@implementation MMTitleListDetailViewController

@synthesize encoder;
@synthesize titleList;

- (id) initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder: aDecoder];
  if(self)
  {
    [self sharedInit];
  }
  return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
  if(self)
  {
    [self sharedInit];
  }
  return self;
}

- (void) sharedInit
{
  cellSizes = [NSMutableDictionary dictionaryWithCapacity: 15];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
  [super viewDidLoad];

  titleLabel.text = titleList.name;
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
  MMTitleDetailCellSize *size = [cellSizes objectForKey: indexPath.key];
  [cell updateWithTitle: title andSize: size];
  
  return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // we have a cached value, return it
  MMTitleDetailCellSize *size = [cellSizes objectForKey: indexPath.key];
  if(size != nil)
  {
    return size.totalHeight;
  }
  
  // loading sizing cell
  if(sizingTitleCell == nil)
  {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *nibName = [KCNibUtils nibName: @"MMTitleDetailCell"];
    
    [bundle loadNibNamed: nibName owner: self options: nil];
    sizingTitleCell = titleCell;
    titleCell = nil;
  }
  
  // update cell to match the table's width
  [titleCell updateSizeWithWidth: tableView.frame.size.width];
  
  // ask cell to compute it's preferred size
  MMTitle *title = [titleList.titles boundSafeObjectAtIndex: indexPath.row];
  size = [sizingTitleCell sizeForTitle: title];
  
  // cache and return
  [cellSizes setObject: size forKey: indexPath.key];
  return size.totalHeight;
}

#pragma mark - Title Track Table Controller delegate
- (void) title: (MMTitle *) title didSelectAudioTrack:(MMAudioTrack *) track
{
  [title selectAudioTrack: track];
  
  NSInteger row = [titleList.titles indexOfObject: title];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow: row inSection: 0];
  NSArray *indexPaths = [NSArray arrayWithObject: indexPath];
  [table reloadRowsAtIndexPaths: indexPaths withRowAnimation: UITableViewRowAnimationNone];
}

- (void) title: (MMTitle *) title didSelectSubtitleTrack:(MMSubtitleTrack *) track
{
  [title selectSubtitleTrack: track];
  
  NSInteger row = [titleList.titles indexOfObject: title];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow: row inSection: 0];
  NSArray *indexPaths = [NSArray arrayWithObject: indexPath];
  [table reloadRowsAtIndexPaths: indexPaths withRowAnimation: UITableViewRowAnimationNone];
}

#pragma mark - User Actions
- (IBAction) cancel:(id)sender
{
  [self.presentingViewController dismissModalViewControllerAnimated: YES];
}

- (IBAction) schedule:(id)sender
{
  MMRemoteEncoderCallback callback = ^{
    [self.presentingViewController dismissModalViewControllerAnimated: YES];    
  };
  
  [loadingView setLoading: YES];
  [encoder scheduleTitleList: titleList withCallback: callback];

}
@end
