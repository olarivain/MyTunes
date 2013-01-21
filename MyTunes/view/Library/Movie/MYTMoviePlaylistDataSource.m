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
#import "MYTMovieCell.h"

@interface MYTMoviePlaylistDataSource ()

@property (strong, nonatomic, readwrite) MYTMovieCell *templateCell;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, strong, readwrite) NSArray *content;

@end

@implementation MYTMoviePlaylistDataSource

#pragma mark - lifecycle
- (void) awakeFromNib {
	[self.table registerNibNamed: @"MYTMovieCell" forCellReuseIdentifier: @"movieCell"];
}


#pragma mark - Synthetic getter/setters
// clear the content on set
- (void) setPlaylist:(MMPlaylist *)playlist {
    _playlist = playlist;
    self.content = nil;
}

- (MYTMovieCell *) templateCell {
    if(_templateCell == nil) {
        _templateCell = [self.table dequeueReusableCellWithIdentifier: @"movieCell"];
    }
    
    return _templateCell;
}

- (void) reload:(BOOL) all {
	self.content = all ? self.playlist.content : self.playlist.unwatchedContent;
    [self.table reloadData];
}

#pragma mark - Table data source
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.content.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MYTMovieCell *cell = [tableView dequeueReusableCellWithIdentifier: @"movieCell"];
	
	MMContent *content = [self.content boundSafeObjectAtIndex: indexPath.row];
	[cell updateWithContent: content];
	
	return cell;
}

#pragma mark - Table Delegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMContent *content = [self.content boundSafeObjectAtIndex: indexPath.row];
    
    // resize the cell appropraitely and size it
    [self.templateCell resizeTo: self.table.frame.size];
	return [self.templateCell idealHeightForContent: content];
}

@end
