//
//  MediaManagementViewController.h
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServersDelegate.h"


@class HomeView;
@class MMServers;

@interface HomeViewController : UIViewController <NSNetServiceDelegate, NSNetServiceBrowserDelegate, MMServersDelegate>
{
  @private
  IBOutlet HomeView *homeView;
  MMServers *servers;
}

- (IBAction) refresh;
- (IBAction) serverSelected: (id) sender;

@end
