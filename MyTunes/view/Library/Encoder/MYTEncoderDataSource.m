//
//  MYTEncoderResourcesDataSource.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/26/13.
//
//

#import <MediaManagement/MMTitleList.h>
#import "MYTEncoderDataSource.h"

#import "MYTEncoderStore.h"
#import "MMEncoderResources.h"
#import "MYTEncoderResourceCell.h"

@interface MYTEncoderDataSource ()
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic) NSArray *resources;

@property (strong, nonatomic) MYTEncoderResourceCell *templateActiveCell;
@property (strong, nonatomic) MYTEncoderResourceCell *templateCell;;

@property (nonatomic) BOOL showingAll;
@end

@implementation MYTEncoderDataSource

- (void) awakeFromNib {
    [self.table registerNibNamed: @"MYTEncoderResourceActiveCell"
          forCellReuseIdentifier: @"encoderActiveCell"];
    [self.table registerNibNamed: @"MYTEncoderResourceCell"
          forCellReuseIdentifier: @"encoderCell"];
}

#pragma mark - synthetic getters
- (NSArray *) selectedResources {
    NSArray *selectedIndexPaths = [self.table indexPathsForSelectedRows];
    
    NSMutableArray *selectedResources = [NSMutableArray arrayWithCapacity: selectedIndexPaths.count];
    for(NSIndexPath *indexPath in selectedIndexPaths) {
        MMTitleList *resource = [self.resources boundSafeObjectAtIndex: indexPath.row];
        [selectedResources addObjectNilSafe: resource];
    }
    return selectedResources;
}

- (MYTEncoderResourceCell *) templateActiveCell {
    if(_templateActiveCell == nil) {
        _templateActiveCell = [self.table dequeueReusableCellWithIdentifier: @"encoderActiveCell"];
    }
    
    return _templateActiveCell;
}

- (MYTEncoderResourceCell *) templateCell {
    if(_templateCell == nil) {
        _templateCell = [self.table dequeueReusableCellWithIdentifier: @"encoderCell"];
    }
    
    return _templateCell;
}

#pragma mark - updating content
- (void) reload:(BOOL) showAll {
    self.showingAll = showAll;
    MMEncoderResources *resources = [MYTEncoderStore sharedInstance].resources;
    self.resources = self.showingAll ? resources.allResources : resources.scheduledResources;
    
    [self.table reloadData];
}

- (void) deselectCurrentCell {
    NSIndexPath *path = [self.table indexPathForSelectedRow];
    [self.table deselectRowAtIndexPath: path
                              animated: YES];
}

#pragma mark - Table data source
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resources.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMTitleList *titleList = [self.resources boundSafeObjectAtIndex: indexPath.row];
    
    NSString *reuseID = titleList.activeTitle == nil ? @"encoderCell" : @"encoderActiveCell";
    MYTEncoderResourceCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseID];
    
    [cell updateWithTitleList: titleList
                   showingAll: self.showingAll];
    
    return cell;
}

#pragma mark - Table delegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMTitleList *titleList = [self.resources boundSafeObjectAtIndex: indexPath.row];
    
    MYTEncoderResourceCell *sizingCell = titleList.activeTitle == nil ? self.templateCell : self.templateActiveCell;
    
    return [sizingCell idealHeightForTitleList: titleList];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MMTitleList *titleList = [self.resources boundSafeObjectAtIndex: indexPath.row];
    [self.delegate didSelectTitleList: titleList];
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    MMTitleList *titleList = [self.resources boundSafeObjectAtIndex: indexPath.row];
    [self.delegate didSelectTitleList: titleList];
}


@end
