//
//  MMAudioTrackTableController.h
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 Edmunds. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMAudioTrackCell;

@interface MMAudioTrackTableController : NSObject<UITableViewDelegate, UITableViewDataSource>
{
  IBOutlet __strong UITableView *table;
  IBOutlet __weak MMAudioTrackCell *audioCell;
  
  __strong MMAudioTrackCell *sizingAudioCell;
  __strong NSArray *audioTracks;
}

@property (nonatomic, readwrite, strong) NSArray *audioTracks;

- (void) refresh;
- (CGFloat) totalHeightForTracks: (NSArray *) tracks;
@end
