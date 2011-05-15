//
//  MediaManagementViewController.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "HomeViewController.h"

#import "NibUtils.h"

#import "MMServer.h"
#import "MMRemoteLibrary.h"

#import "MMServers.h"
#import "HomeView.h"
#import "ServerView.h"
#import "MainViewController_iPad.h"

@interface HomeViewController()
@property (nonatomic, readwrite, retain) HomeView *homeView;
@property (nonatomic, readwrite, retain) UIActivityIndicatorView *activityIndicator;

@end

@implementation HomeViewController

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

#pragma mark - Button Handlers
- (IBAction) refresh
{
  [servers refreshServerList];
}

- (IBAction) serverSelected:(id)sender
{
  activityIndicator.hidden = FALSE;
  [activityIndicator startAnimating];
  
  // load next view controller
  NSString *nibName = [NibUtils nibName: @"MainViewController"];
  MainViewController_iPad *mainViewController = [[MainViewController_iPad alloc] initWithNibName: nibName bundle:[NSBundle mainBundle]];
 
  // grab server and wire it in
  ServerView *view = (ServerView*) sender;
  MMServer *server = view.server;
  mainViewController.server = server;
  
  // and load content.
  [server.library loadHeadersWithBlock:^(void) {
    [activityIndicator stopAnimating];
    activityIndicator.hidden = TRUE;
    
    [[self navigationController] pushViewController:mainViewController animated:TRUE];
    [mainViewController release];
  }];

}

#pragma mark - ServersDelegate methods
- (void) didRefresh:(MMServers *)sender
{
  NSLog(@"Did refresh, %i", [[servers servers] count]);
  [homeView setServers: [servers servers]];
  for(ServerView *serverView in [homeView serverViews])
  {
    // remove and add targets.
    [serverView removeTarget: self action: @selector(serverSelected:) forControlEvents: UIControlEventTouchUpInside];
    [serverView addTarget: self action:@selector(serverSelected:) forControlEvents:UIControlEventTouchUpInside];
  }
}

@end
