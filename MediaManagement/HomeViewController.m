//
//  MediaManagementViewController.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"

#import "Servers.h"
#import "HomeView.h"

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

}

- (void) viewDidAppear:(BOOL)animated
{
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

#pragma mark - ServersDelegate methods
- (void) didRefresh:(Servers *)sender
{
  NSLog(@"Did refresh, %i", [[servers servers] count]);
  [homeView setServers: [servers servers]];
}

- (void) willRefresh:(Servers *)sender
{
  NSLog(@"Will refresh, %i", [[servers servers] count]);
}

@end
