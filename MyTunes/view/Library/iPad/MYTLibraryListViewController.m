//
//  MYTPlaylistViewController.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/20/13.
//
//

#import <MediaManagement/MMLibrary.h>
#import <MediaManagement/MMPlaylist.h>
#import "MYTLibraryListViewController.h"

#import "MYTLibraryStore.h"

#import "MYTPlaylistCell.h"

@interface MYTLibraryListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet id<MYTPlaylistControllerDelegate> delegate;

@end

@implementation MYTLibraryListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.table registerNibNamed: @"MMPlaylistCell"
                  forCellReuseIdentifier: @"playlistCell"];
    
    // select the first row if we have one
    if(self.table.numberOfSections > 0 && [self.table numberOfRowsInSection: 0] > 0) {
        [self.table selectRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection: 0]
                                animated: NO
                          scrollPosition: UITableViewScrollPositionNone];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}

#pragma mark - Table data source
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    // playlists + encoders
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 2 : 2;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MYTPlaylistCell *cell = [tableView dequeueReusableCellWithIdentifier: @"playlistCell"];

    NSString *title = @"";
    if(indexPath.section == 0) {
        MMLibrary *library = [MYTLibraryStore sharedInstance].currentLibrary;
        MMPlaylist *playlist = [library.playlists boundSafeObjectAtIndex: indexPath.row];
        title = playlist.name;
    } else {
        title = indexPath.row == 0 ? @"Resources" : @"Queue";
    }
    
    [cell updateWithTitle: title];
    return cell;
}

#pragma mark - Table view delegate
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0 ? @"Playlists" : @"Encoder";
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        [self selectPlaylistAtIndexPath: indexPath];
    } else {
        [self selectEncodingPlaylistAtIndexPath: indexPath];
    }
}

- (void) selectPlaylistAtIndexPath: (NSIndexPath *) indexPath {
    MYTLibraryStore *store = [MYTLibraryStore sharedInstance];
    store.currentPlaylist = [store.currentLibrary.playlists boundSafeObjectAtIndex: indexPath.row];

    [self.delegate didSelectPlaylist: store.currentPlaylist];
}

- (void) selectEncodingPlaylistAtIndexPath: (NSIndexPath *) indexPath {
    
}

@end
