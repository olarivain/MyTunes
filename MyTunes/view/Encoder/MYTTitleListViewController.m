//
//  MYTTitleListViewController.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/27/13.
//
//
#import <MediaManagement/MMTitleList.h>
#import <MediaManagement/MMTitle.h>

#import "MYTTitleListViewController.h"

#import "MYTEncoderStore.h"

#import "MYTTitleCell.h"
#import "MYTAudioSubtitleTrackCell.h"

@interface MYTTitleListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic, readwrite) MYTTitleCell *templateTitleCell;
@property (strong, nonatomic, readwrite) MYTAudioSubtitleTrackCell *templateAudioSubtitleCell;

@end

@implementation MYTTitleListViewController

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Encoder";
    
	self.navigationItem.rightBarButtonItem = self.doneButton;
	self.navigationItem.leftBarButtonItem = self.cancelButton;
    
    [self.table registerNibNamed: @"MYTTitleCell"
          forCellReuseIdentifier: @"titleCell"];
    [self.table registerNibNamed: @"MYTAudioSubtitleTrackCell"
          forCellReuseIdentifier: @"audioSubtitleTrackCell"];
    
    MYTEncoderStore *store = [MYTEncoderStore sharedInstance];
    [store loadResource: self.titleList
               callback:^(NSError *error) {
                   [self didLoadResource: error];
               }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - synthetic getter/setters
- (MYTTitleCell *) templateTitleCell {
    if(_templateTitleCell == nil) {
        _templateTitleCell = [self.table dequeueReusableCellWithIdentifier: @"titleCell"];
    }
    
    return _templateTitleCell;
}

- (MYTAudioSubtitleTrackCell *) templateAudioSubtitleCell {
    if(_templateAudioSubtitleCell == nil) {
        _templateAudioSubtitleCell = [self.table dequeueReusableCellWithIdentifier: @"audioSubtitleTrackCell"];
    }
    
    return _templateAudioSubtitleCell;
}

#pragma mark - Loading resource
- (void) didLoadResource: (NSError *) error {
    if([error present]) {
        return;
    }
    
    [self.activityIndicator stopAnimating];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.table reloadData];
    [UIView animateWithDuration: SHORT_ANIMATION_DURATION
                     animations:^{
                         self.table.alpha = 1.0;
                     }];
}

#pragma mark - table data source
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleList.titles.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MMTitle *title = [self.titleList.titles boundSafeObjectAtIndex: section];
    return 1 + title.audioTracks.count + title.subtitleTracks.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        return [self tableView: tableView titleCellForRowAtIndexPath: indexPath];
    }
    
    return [self tableView: tableView audioSubCellForRowAtIndexPath: indexPath];
}

- (UITableViewCell *) tableView:(UITableView *)tableView
     titleCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMTitle *title = [self.titleList.titles boundSafeObjectAtIndex: indexPath.section];
    
    MYTTitleCell *cell = [tableView dequeueReusableCellWithIdentifier: @"titleCell"];
    [cell updateWithTitle: title];
    return cell;
}
- (UITableViewCell *) tableView:(UITableView *)tableView audioSubCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMTitle *title = [self.titleList.titles boundSafeObjectAtIndex: indexPath.section];
    
    MYTAudioSubtitleTrackCell *cell = [tableView dequeueReusableCellWithIdentifier: @"audioSubtitleTrackCell"];
    
    NSInteger audioIndex = indexPath.row - 1;
    MMAudioTrack *audio = [title.audioTracks boundSafeObjectAtIndex: audioIndex];
    if(audio) {
        [cell updateWithAudioTrack: audio];
        return cell;
    }
    
    NSInteger subtitleIndex = indexPath.row - title.audioTracks.count - 1;
    MMSubtitleTrack *subtitle = [title.subtitleTracks boundSafeObjectAtIndex: subtitleIndex];
    [cell updateWithSubtitleTrack: subtitle];
    
    return cell;
}

#pragma mark - table delegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        return self.templateTitleCell.frame.size.height;
    }
    return self.templateAudioSubtitleCell.frame.size.height;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        return;
    }
    
    MMTitle *title = [self.titleList.titles boundSafeObjectAtIndex: indexPath.section];
    NSInteger audioIndex = indexPath.row - 1;
    MMAudioTrack *audio = [title.audioTracks boundSafeObjectAtIndex: audioIndex];
    if(audio) {
        [title selectAudioTrack: audio];
    } else {
        NSInteger subtitleIndex = indexPath.row - title.audioTracks.count - 1;
        MMSubtitleTrack *subtitle = [title.subtitleTracks boundSafeObjectAtIndex: subtitleIndex];
        [title selectSubtitleTrack: subtitle];
    }
    
    NSIndexSet *set = [NSIndexSet indexSetWithIndex: indexPath.section];
    [tableView reloadSections: set
             withRowAnimation: UITableViewRowAnimationNone];
}

#pragma mark - Button
- (IBAction) done: (id)sender {
    [self.activityIndicator startAnimating];
    
    MYTEncoderStore *store = [MYTEncoderStore sharedInstance];
    [store encodeResource: self.titleList
                 callback:^(NSError *error) {
                     [self didEncodeResource: error];
                 }];
}

- (void) didEncodeResource: (NSError *) error {
    if([error present]) {
        return;
    }
    
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 InvokeBlock(self.dismissBlock, YES);
                             }];
}

- (IBAction) cancel: (id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 InvokeBlock(self.dismissBlock, NO);
                             }];
}

@end
