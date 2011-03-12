//
//  MediaManagementViewController.h
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServersDelegate.h"
#import "MainViewController.h"


@class HomeView;
@class Servers;
@class MainViewController_iPad;

@interface HomeViewController : UIViewController <NSNetServiceDelegate, NSNetServiceBrowserDelegate, ServersDelegate>
{
  @private
  IBOutlet HomeView *homeView;
  IBOutlet UIViewController<MainViewController> *mainViewController;
  Servers *servers;
}

- (IBAction) refresh;
- (IBAction) serverSelected: (id) sender;

@end
