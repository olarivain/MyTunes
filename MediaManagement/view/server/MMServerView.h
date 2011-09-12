//
//  ServerIcon.h
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMServer;

@interface MMServerView : UIControl 
{
  @private
  MMServer *server;
  IBOutlet UILabel *label;
}

@property (nonatomic, readwrite, retain) MMServer* server;

- (void) update;

@end
