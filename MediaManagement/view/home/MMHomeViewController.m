//
//  MediaManagementViewController.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMHomeViewController.h"

#import "NibUtils.h"

#import "MMServer.h"
#import "MMRemoteLibrary.h"

#import "MMServers.h"
#import "MMHomeView.h"
#import "MMServerView.h"
#import "MMLibraryViewController_iPad.h"

@interface MMHomeViewController()
@property (nonatomic, readwrite, retain) MMHomeView *homeView;
@property (nonatomic, readwrite, retain) UIActivityIndicatorView *activityIndicator;
- (void) setLoading: (BOOL) loading;
@end

@implementation MMHomeViewController

- (void)dealloc
{
  self.homeView = nil;
  self.activityIndicator = nil;
  [servers release];
  [super dealloc];
}

@synthesize activityIndicator;
@synthesize homeView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  servers = [[MMServers alloc] init];
  [servers setDelegate: self];
  [self refresh];
}

- (void)viewDidUnload
{
  self.homeView = nil;
  self.activityIndicator = nil;
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - Loading activity
- (void) setLoading: (BOOL) loading
{
  if(loading)
  {
    [activityIndicator startAnimating]; 
  }
  else 
  {
    [activityIndicator stopAnimating];
  }
  activityIndicator.hidden = !loading;
}


#pragma mark - Button Handlers
- (IBAction) refresh
{
  [servers refreshServerList];
}

- (IBAction) serverSelected:(id)sender
{
  [self setLoading: TRUE];
  
  // load next view controller
  NSString *nibName = [NibUtils nibName: @"MMLibraryViewController"];
  MMLibraryViewController_iPad *libraryViewController = [[MMLibraryViewController_iPad alloc] initWithNibName: nibName bundle:[NSBundle mainBundle]];
 
  // grab server and wire it in
  MMServerView *view = (MMServerView*) sender;
  MMServer *server = view.server;
  libraryViewController.server = server;
  
  // and load content.
  [server.library loadHeadersWithBlock:^(void) {
    [self setLoading: FALSE];
    [[self navigationController] pushViewController:libraryViewController animated:TRUE];
    [libraryViewController release];
  }];

}

#pragma mark - ServersDelegate methods
- (void) didRefresh:(MMServers *)sender
{
  NSLog(@"Did refresh, %i", [[servers servers] count]);
  [homeView setServers: [servers servers]];
  for(MMServerView *serverView in [homeView serverViews])
  {
    // remove and add targets.
    [serverView removeTarget: self action: @selector(serverSelected:) forControlEvents: UIControlEventTouchUpInside];
    [serverView addTarget: self action:@selector(serverSelected:) forControlEvents:UIControlEventTouchUpInside];
  }
}

@end
