//
//  ServerIcon.h
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Server;

@interface ServerView : UIControl 
{
  @private
  Server *server;
  IBOutlet UILabel *label;
}

@property (readwrite, retain) Server* server;

@end
