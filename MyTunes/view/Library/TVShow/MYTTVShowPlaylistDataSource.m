//
//  MYTTVShowPlaylistDataSource.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/21/13.
//
//

#import <KraCommons/KCViewDequeuer.h>

#import "MYTTVShowPlaylistDataSource.h"

#import "MMTVShowPlaylist.h"
#import "MMTVShowSeason.h"

#import "MYTTVShowHeader.h"
#import "MYTContentCell.h"

@interface MYTTVShowPlaylistDataSource ()

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) MYTContentCell *templateCell;
@property (strong, nonatomic) MYTTVShowHeader *templateHeader;

@property (copy, nonatomic) NSArray *sortedSeasons;

@property (nonatomic, readonly) MMTVShowPlaylist *tvShowPlaylist;

@property (strong, nonatomic) KCViewDequeuer *viewDequeuer;
@end

@implementation MYTTVShowPlaylistDataSource

#pragma mark - lifecycle
- (void) awakeFromNib {
    [self.table registerNibNamed: @"MYTTVShowCell" forCellReuseIdentifier: @"tvShowCell"];
    
    self.viewDequeuer = [[KCViewDequeuer alloc] init];
    [self.viewDequeuer registerNibName: @"MYTTVShowHeader"
                    forReuseIdentifier: @"showHeader"];
}

#pragma mark - Synthetic getters
- (MMTVShowPlaylist *) tvShowPlaylist {
    return (MMTVShowPlaylist *) self.playlist;
}

// clear the content on set
- (void) setPlaylist:(MMPlaylist *)playlist {
    _playlist = playlist;
    self.contentList = nil;
}

- (MYTContentCell *) templateCell {
    if(_templateCell == nil) {
        _templateCell = [self.table dequeueReusableCellWithIdentifier: @"tvShowCell"];
    }
    
    return _templateCell;
}

- (MYTTVShowHeader *) templateHeader {
    if(_templateHeader == nil) {
       _templateHeader = (MYTTVShowHeader *) [self.viewDequeuer loadViewWithIdentifier: @"showHeader"];
    }
    
    return _templateHeader;
}

#pragma mark - updating content
- (void) reload:(BOOL)unwatched {
    self.sortedSeasons = unwatched ? self.tvShowPlaylist.sortedSeasons: self.tvShowPlaylist.sortedUnwatchedSeasons;
    [self.table reloadData];
}

#pragma mark - Table Data source
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sortedSeasons.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MMTVShowSeason *season = [self.sortedSeasons boundSafeObjectAtIndex: section];
    return season.episodes.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MYTContentCell *cell = [tableView dequeueReusableCellWithIdentifier: @"tvShowCell"];
	
    MMTVShowSeason *season = [self.sortedSeasons boundSafeObjectAtIndex: indexPath.section];
	MMContent *content = [season.episodes boundSafeObjectAtIndex: indexPath.row];
	[cell updateWithContent: content];
	
	return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MMTVShowSeason *season = [self.sortedSeasons boundSafeObjectAtIndex: section];
    
    MYTTVShowHeader *header = (MYTTVShowHeader *) [self.viewDequeuer dequeueReusableViewWithIdentifier: @"showHeader"];
    
    [header updateWithShow: season];
    return header;
}

#pragma mark - Table Delegate
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.templateHeader.frame.size.height;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMTVShowSeason *season = [self.sortedSeasons boundSafeObjectAtIndex: indexPath.section];
	MMContent *content = [season.episodes boundSafeObjectAtIndex: indexPath.row];
    
    // resize the cell appropraitely and size it
    [self.templateCell resizeTo: self.table.frame.size];
	return [self.templateCell idealHeightForContent: content];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MMTVShowSeason *season = [self.sortedSeasons boundSafeObjectAtIndex: indexPath.section];
	MMContent *content = [season.episodes boundSafeObjectAtIndex: indexPath.row];
    
    [self.delegate didSelectContent: content
                    withContentList: season.episodes];
}

@end
