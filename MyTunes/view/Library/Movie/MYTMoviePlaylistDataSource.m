//
//  MYTMoviePlaylistDataSource.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/21/13.
//
//

#import <MediaManagement/MMMoviesPlaylist.h>
#import <MediaManagement/MMContent.h>

#import "MYTMoviePlaylistDataSource.h"

#import "MYTMovieCell.h"

@interface MYTMoviePlaylistDataSource ()
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation MYTMoviePlaylistDataSource

- (void) awakeFromNib {
	[self.table registerNibNamed: @"MYTMovieCell" forCellReuseIdentifier: @"movieCell"];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.playlist.content.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MYTMovieCell *cell = [tableView dequeueReusableCellWithIdentifier: @"movieCell"];
	
	MMContent *content = [self.playlist.content boundSafeObjectAtIndex: indexPath.row];
    if(content.unplayed) {
        DDLogInfo(@"Player!");
    }
	[cell updateWithContent: content];
	
	return cell;
}

@end
