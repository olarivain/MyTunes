//
//  MediaManagementViewController.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "HomeViewController.h"

#import "Servers.h"
#import "HomeView.h"
#import "ServerView.h"
#import "MainViewController_iPad.h"

@implementation HomeViewController

- (void)dealloc
{
  [servers release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  servers = [[Servers alloc] init];
  [servers setDelegate: self];
  [self refresh];
}

- (void)viewDidUnload
{
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
  ServerView *view = (ServerView*) sender;
  [mainViewController setServer: [view server]];
  
  [[self navigationController] pushViewController:mainViewController animated:TRUE];
}

#pragma mark - ServersDelegate methods
- (void) didRefresh:(Servers *)sender
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
