//
//  MediaManagementViewController.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "HomeViewController.h"

#import "MMServers.h"
#import "HomeView.h"
#import "ServerView.h"
#import "MainViewController_iPad.h"
#import "NibUtils.h"

@interface HomeViewController()
@property (nonatomic, readwrite, retain) HomeView *homeView;

@end

@implementation HomeViewController

- (void)dealloc
{
  self.homeView = nil;
  [servers release];
  [super dealloc];
}

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
  
  NSString *nibName = [NibUtils nibName: @"MainViewController"];

  MainViewController_iPad *mainViewController = [[MainViewController_iPad alloc] initWithNibName: nibName bundle:[NSBundle mainBundle]];
  [mainViewController setServer: [view server]];
  [[self navigationController] pushViewController:mainViewController animated:TRUE];
  [mainViewController release];
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
