//
//  MMEncoderTableController.h
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/30/11.
//  Copyright (c) 2011 Edmunds. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMRemoteEncoder;

@interface MMEncoderTableController : NSObject<UITableViewDataSource, UITableViewDelegate>
{
  IBOutlet UITableView *table;
  __strong MMRemoteEncoder *encoder;
}

@property (nonatomic, readwrite, strong) MMRemoteEncoder *encoder;

- (void) refresh;

@end
