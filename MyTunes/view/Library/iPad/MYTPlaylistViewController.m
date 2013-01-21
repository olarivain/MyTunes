//
//  MYTPlaylistViewController.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/20/13.
//
//

#import <MediaManagement/MMLibrary.h>
#import <MediaManagement/MMPlaylist.h>
#import "MYTPlaylistViewController.h"

#import "MYTLibraryStore.h"

#import "MYTPlaylistCell.h"

@interface MYTPlaylistViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *playlistTable;

@end

@implementation MYTPlaylistViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.playlistTable registerNibNamed: @"MMPlaylistCell"
                  forCellReuseIdentifier: @"playlistCell"];
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

@end
