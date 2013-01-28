//
//  MYTMoviePlaylistDataSource.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/21/13.
//
//

#import <MediaManagement/MMContent.h>
#import <MediaManagement/MMPlaylist.h>

#import "MYTMoviePlaylistDataSource.h"

#import "MMMoviesPlaylist.h"
#import "MYTContentCell.h"

@interface MYTMoviePlaylistDataSource ()

@property (strong, nonatomic, readwrite) MYTContentCell *templateCell;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (nonatomic, readonly) MMMoviesPlaylist *moviesPlaylist;

@end

@implementation MYTMoviePlaylistDataSource

#pragma mark - lifecycle
- (void) awakeFromNib {
	[self.table registerNibNamed: @"MYTMovieCell" forCellReuseIdentifier: @"movieCell"];
}


#pragma mark - Synthetic getter/setters
- (MMMoviesPlaylist *) moviesPlaylist {
    return (MMMoviesPlaylist *) self.playlist;
}
// clear the content on set
- (void) setPlaylist:(MMPlaylist *)playlist {
    _playlist = playlist;
    self.contentList = nil;
}

- (MYTContentCell *) templateCell {
    if(_templateCell == nil) {
        _templateCell = [self.table dequeueReusableCellWithIdentifier: @"movieCell"];
    }
    
    return _templateCell;
}

#pragma mark - Playlistdata source delegate
- (void) reload:(BOOL) all {
	self.contentList = all ? self.moviesPlaylist.content : self.moviesPlaylist.unwatchedMovies;
    [self.table reloadData];
}

- (void) deselectCurrentCell {
    NSIndexPath *indexPath = [self.table indexPathForSelectedRow];
    [self.table deselectRowAtIndexPath: indexPath
                              animated: YES];
}

#pragma mark - Table data source
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentList.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MYTContentCell *cell = [tableView dequeueReusableCellWithIdentifier: @"movieCell"];
	
	MMContent *content = [self.contentList boundSafeObjectAtIndex: indexPath.row];
	[cell updateWithContent: content];
	
	return cell;
}

#pragma mark - Table Delegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMContent *content = [self.contentList boundSafeObjectAtIndex: indexPath.row];
    
    // resize the cell appropraitely and size it
    [self.templateCell resizeTo: self.table.frame.size];
	return [self.templateCell idealHeightForContent: content];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MMContent *movie = [self.contentList boundSafeObjectAtIndex: indexPath.row];
    [self.delegate didSelectContent: movie
                    withContentList: self.contentList];
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    MMContent *movie = [self.contentList boundSafeObjectAtIndex: indexPath.row];
    [self.delegate didDeselectContent: movie
                      withContentList: self.contentList];
}

@end
