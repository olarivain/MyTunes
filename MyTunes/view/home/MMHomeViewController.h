//
//  MediaManagementViewController.h
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMServersDelegate.h"


@class MMHomeView;
@class MMServers;

@interface MMHomeViewController : UIViewController <NSNetServiceDelegate, NSNetServiceBrowserDelegate, MMServersDelegate>
{
  @private
  IBOutlet MMHomeView *homeView;
  IBOutlet UIActivityIndicatorView *activityIndicator;
  MMServers *servers;
}

- (IBAction) serverSelected: (id) sender;

@end
