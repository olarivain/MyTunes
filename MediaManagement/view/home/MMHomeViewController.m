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

#import "MMLibraryViewController.h"
#import "MMLibraryViewController_iPad.h"
#import "MMLibraryViewController_iPhone.h"

@interface MMHomeViewController()
@property (nonatomic, readwrite, retain) MMHomeView *homeView;
@property (nonatomic, readwrite, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, readwrite, retain) MMServers *servers;
- (void) setLoading: (BOOL) loading;
@end

@implementation MMHomeViewController

- (void)dealloc
{
  self.homeView = nil;
  self.activityIndicator = nil;
  self.servers = nil;
  [super dealloc];
}

@synthesize activityIndicator;
@synthesize homeView;
@synthesize servers;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void) awakeFromNib
{
  self.servers = [[[MMServers alloc] init] autorelease];
  servers.delegate = self;
}
- (void)viewDidLoad
{
  [super viewDidLoad];
  homeView.servers = [servers servers];
  [servers startSearch];
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


- (MMLibraryViewController*) loadLibraryController
{
  NSString *nibName = [NibUtils nibName: @"MMLibraryViewController"];
  if([NibUtils isiPad])
  {
    return [[[MMLibraryViewController_iPad alloc] initWithNibName: nibName bundle:[NSBundle mainBundle]] autorelease];
  }

  return [[[MMLibraryViewController_iPhone alloc] initWithNibName: nibName bundle:[NSBundle mainBundle]] autorelease];
}

- (IBAction) serverSelected:(id)sender
{
  [self setLoading: TRUE];
  
  // load next view controller
  MMLibraryViewController *libraryViewController = [self loadLibraryController];
  
  // grab server and wire it in
  MMServerView *view = (MMServerView*) sender;
  MMServer *server = view.server;
  libraryViewController.server = server;
  
  // and load content.
  MMRemoteLibraryCallback callback = ^(void) {
    [self setLoading: FALSE];
    [[self navigationController] pushViewController:libraryViewController animated:TRUE];
  };
  [server.library loadHeadersWithBlock: callback];

}

#pragma mark - ServersDelegate methods
- (void) didRefresh:(MMServers *)sender
{
  NSLog(@"Did refresh, %i", [[sender servers] count]);
  [homeView setServers: [sender servers]];
  for(MMServerView *serverView in [homeView serverViews])
  {
    // remove and add targets.
    [serverView removeTarget: self action: @selector(serverSelected:) forControlEvents: UIControlEventTouchUpInside];
    [serverView addTarget: self action:@selector(serverSelected:) forControlEvents:UIControlEventTouchUpInside];
  }
}

@end
