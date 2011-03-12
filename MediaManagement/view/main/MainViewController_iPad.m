//
//  MainViewController_iPad.m
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MainViewController_iPad.h"

#import "Server.h"
#import "EditController.h"
#import "BaseMainViewController.h"

@interface MainViewController_iPad(private)
- (void) initialize;
@end

@implementation MainViewController_iPad

- (id) initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder: aDecoder];
  if(self)
  {
    [self initialize];
  }
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) 
  {
    [self initialize];
  }
  return self;
}

- (void) dealloc
{
  [baseController release];
  [server release];
  [super dealloc];
}

- (void) initialize
{
  baseController = [[BaseMainViewController alloc] init];
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return YES;
}

#pragma mark - Server get/set
- (Server*) server
{
  return server;
}

- (void) setServer:(Server *)newServer
{
  if(server == newServer)
  {
    return;
  }
  
  [newServer retain];
  [server release];
  server = newServer;
  
  [[self navigationItem] setTitle: [server name]];
}

#pragma mark - Action handlers
- (IBAction) editPressed: (id) sender
{
  [editController setModalPresentationStyle:UIModalPresentationFormSheet];
  [self presentModalViewController:editController animated:TRUE];
}

@end
