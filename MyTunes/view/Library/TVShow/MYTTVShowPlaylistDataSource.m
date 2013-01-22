//
//  MYTTVShowPlaylistDataSource.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/21/13.
//
//

#import "MYTTVShowPlaylistDataSource.h"

#import "MMTVShowPlaylist.h"
#import "MMTVShowSeason.h"

#import "MYTContentCell.h"

@interface MYTTVShowPlaylistDataSource ()

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) MYTContentCell *templateCell;

@property (copy, nonatomic) NSArray *sortedSeasons;

@property (nonatomic, readonly) MMTVShowPlaylist *tvShowPlaylist;

@end

@implementation MYTTVShowPlaylistDataSource

#pragma mark - lifecycle
- (void) awakeFromNib {
    [self.table registerNibNamed: @"MYTTVShowCell" forCellReuseIdentifier: @"tvShowCell"];
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

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    MMTVShowSeason *season = [self.sortedSeasons boundSafeObjectAtIndex: section];
    return season.humanReadableName;
}

#pragma mark - Table Delegate
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
