//
//  MediaManagementViewController.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//
#import <KraCommons/KCNibUtils.h>

#import "MMHomeViewController.h"

#import "MMServer.h"
#import "MMRemoteLibrary.h"

#import "MMServers.h"
#import "MMHomeView.h"
#import "MMServerView.h"

#import "MMLibraryViewController.h"
#import "MMLibraryViewController_iPad.h"
#import "MMLibraryViewController_iPhone.h"

@interface MMHomeViewController()
@property (nonatomic, readwrite, strong) MMHomeView *homeView;
@property (nonatomic, readwrite, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, readwrite, strong) MMServers *servers;
- (void) setLoading: (BOOL) loading;
@end

@implementation MMHomeViewController

- (id) initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder: aDecoder];
  if(self)
  {
    self.servers = [[MMServers alloc] init];
    servers.delegate = self;
  }
  
  return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
  if(self)
  {
    self.servers = [[MMServers alloc] init];
    servers.delegate = self;
  }
  return self;
}


@synthesize activityIndicator;
@synthesize homeView;
@synthesize servers;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

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
    activityIndicator.hidden = !loading;
  }
  else 
  {
    [activityIndicator stopAnimating];
  }
}

#pragma mark - Moving to next view controller
- (UIViewController<MMLibraryViewController> *) loadLibraryController
{
  NSString *nibName = [KCNibUtils nibName: @"MMLibraryViewController"];
  Class clazz = isiPad ? [MMLibraryViewController_iPad class] : [MMLibraryViewController_iPhone class];
  return [[clazz alloc] initWithNibName: nibName bundle:[NSBundle mainBundle]];
}

- (IBAction) serverSelected:(id)sender
{
  [self setLoading: TRUE];
  
  // load next view controller
  UIViewController<MMLibraryViewController> *libraryViewController = [self loadLibraryController];
  
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
- (void) willRefresh:(MMServers *)sender
{
  // we don't really care actually.  
}

- (void) didRefresh:(MMServers *)sender
{
  homeView.servers = sender.servers;
  for(MMServerView *serverView in homeView.serverViews)
  {
    // remove and add targets.
    [serverView removeTarget: self action: @selector(serverSelected:) forControlEvents: UIControlEventTouchUpInside];
    [serverView addTarget: self action:@selector(serverSelected:) forControlEvents:UIControlEventTouchUpInside];
  }
}

@end
