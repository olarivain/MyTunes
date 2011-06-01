//
//  EditController.m
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMEditController.h"

@implementation MMEditController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
  self.contentGroup = nil;
  self.currentItem= nil;
  self.playlist = nil;
  [super dealloc];
}

@synthesize playlist;
@synthesize contentGroup;
@synthesize currentItem;

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return YES;
}

#pragma mark - Action Handler
- (void) dismiss
{
  [[self parentViewController] dismissModalViewControllerAnimated:TRUE];
}
- (IBAction) save: (id) sender
{
}

- (IBAction) cancel: (id) sender
{
  [self dismiss];  
}


@end
