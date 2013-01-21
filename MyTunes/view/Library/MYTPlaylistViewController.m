//
//  MYTPlaylistViewController.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/21/13.
//
//
#import <MediaManagement/MMPlaylist.h>
#import "MYTPlaylistViewController.h"

#import "MYTMoviePlaylistDataSource.h"

#import "MYTLibraryStore.h"

@interface MYTPlaylistViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet MYTMoviePlaylistDataSource *moviePlaylistDataSource;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MYTPlaylistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refreshSelectedPlaylist {
    MMPlaylist *playlist = [MYTLibraryStore sharedInstance].currentPlaylist;
	// swap the data source on the table
    switch (playlist.kind) {
        case MOVIE:
			self.moviePlaylistDataSource.playlist = playlist;
            self.table.dataSource = self.moviePlaylistDataSource;
			self.table.delegate = self.moviePlaylistDataSource;
            break;
		case TV_SHOW:
			self.table.dataSource = nil;
			self.table.delegate = nil;
        default:
            break;
    }
    
	// fade the table out and start the spinning spinner
	[UIView animateWithDuration: SHORT_ANIMATION_DURATION
                     animations:^{
                         self.table.alpha = 0.0f;
                     }];
	[self.activityIndicator startAnimating];
    
    // fire a load request
    MYTLibraryStore *store = [MYTLibraryStore sharedInstance];
    [store loadPlaylist:^(NSError *error) {
        [self didLoadPlaylist: error];
    }];
}

- (void) didLoadPlaylist: (NSError *) error {
    if([error present]) {
        return;
    }
    
    [self.activityIndicator stopAnimating];
    [self.table reloadData];
    // fade the table out and start the spinning spinner
	[UIView animateWithDuration: SHORT_ANIMATION_DURATION
                     animations:^{
                         self.table.alpha = 1.0f;
                     }];

}

@end
