//
//  MYTPlaylistViewController.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/20/13.
//
//

#import <KraCommons/KCViewDequeuer.h>

#import <MediaManagement/MMLibrary.h>
#import <MediaManagement/MMPlaylist.h>
#import "MYTLibraryListViewController.h"

#import "MYTLibraryStore.h"

#import "MYTLibraryHeader.h"
#import "MYTPlaylistCell.h"

@interface MYTLibraryListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet id<MYTPlaylistControllerDelegate> delegate;

@property (strong, nonatomic) KCViewDequeuer *headerDequeuer;
@property (strong, nonatomic) MYTLibraryHeader *templateHeader;
@end

@implementation MYTLibraryListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // configure table
    [self.table registerNibNamed: @"MMPlaylistCell"
                  forCellReuseIdentifier: @"playlistCell"];
    
    // configure header dequeuer
    self.headerDequeuer = [[KCViewDequeuer alloc] init];
    [self.headerDequeuer registerNibName: @"MYTLibraryHeader"
                      forReuseIdentifier: @"libraryHeader"];
    
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

#pragma mark - synthetic getter
- (MYTLibraryHeader *) templateHeader {
    if (_templateHeader == nil) {
        _templateHeader = (MYTLibraryHeader *) [self.headerDequeuer dequeueReusableViewWithIdentifier: @"libraryHeader"];
    }
    
    return _templateHeader;
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

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MYTLibraryHeader *header = (MYTLibraryHeader *) [self.headerDequeuer dequeueReusableViewWithIdentifier: @"libraryHeader"];
    
    NSString *title = section == 0 ? @"Resources" : @"Encoder";
    [header updateWithTitle: title];
    
    return header;
}


#pragma mark - Table view delegate
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.templateHeader.frame.size.height;
}
- (NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // cancel selection if the row is already selected
    if([indexPath isEqual: [tableView indexPathForSelectedRow]]) {
        return nil;
    }
    return indexPath;
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
