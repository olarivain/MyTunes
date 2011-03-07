//
//  MediaManagementViewController.h
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServersDelegate.h"
@class HomeView;
@class Servers;
@interface HomeViewController : UIViewController <NSNetServiceDelegate, NSNetServiceBrowserDelegate, ServersDelegate>
{
  @private
  IBOutlet HomeView *homeView;
  Servers *servers;
}

- (IBAction) refresh;

@end
