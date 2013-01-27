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
@end

@implementation MYTEncoderDataSource

- (void) awakeFromNib {
    [self.table registerNibNamed: @"MYTEncoderResourceActiveCell"
          forCellReuseIdentifier: @"encoderActiveCell"];
    [self.table registerNibNamed: @"MYTEncoderResourceCell"
          forCellReuseIdentifier: @"encoderCell"];
}

#pragma mark - synthetic getters
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

- (void) reload:(BOOL)filtered {
    MMEncoderResources *resources = [MYTEncoderStore sharedInstance].resources;
    self.resources = filtered ? resources.scheduledResources : resources.allResources;
    
    [self.table reloadData];
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
    
    [cell updateWithTitleList: titleList];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMTitleList *titleList = [self.resources boundSafeObjectAtIndex: indexPath.row];
    
    MYTEncoderResourceCell *sizingCell = titleList.activeTitle == nil ? self.templateCell : self.templateActiveCell;
    
    return [sizingCell idealHeightForTitleList: titleList];
}


@end
