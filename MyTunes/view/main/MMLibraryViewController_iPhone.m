//
//  MainViewController_iPhone.m
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMLibraryViewController_iPhone.h"
#import "MMEditController.h"
#import "MMServer.h"

@implementation MMLibraryViewController_iPhone

@synthesize server;

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 }
 */

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Server get/set
- (MMServer*) server
{
	return server;
}

- (void) setServer:(MMServer *)newServer
{
	if(server == newServer)
	{
		return;
	}
	
	server = newServer;
	
	[[self navigationItem] setTitle: [server name]];
}

#pragma mark - Action handlers
- (IBAction) editPressed: (id) sender
{
}


@end
