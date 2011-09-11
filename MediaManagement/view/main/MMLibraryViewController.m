//
//  MMLibraryController.m
//  MediaManagement
//
//  Created by Kra on 5/15/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMLibraryViewController.h"
#import "MMServer.h"

@implementation MMLibraryViewController

@synthesize server;
@synthesize selectedPlaylist;
@synthesize selectedContentGroup;

- (void) dealloc
{
  self.server = nil;
  self.selectedPlaylist = nil;
  self.selectedContentGroup = nil;
  [super dealloc];
}

- (IBAction) editPressed: (id) sender
{
  @throw [NSException exceptionWithName:@"IllegalOperationException" reason:@"MMLibraryViewController.editPressed: MUST be overriden by subclasses" userInfo: nil];
}

- (IBAction) selectedPlaylistContentType: (id) sender
{
  @throw [NSException exceptionWithName:@"IllegalOperationException" reason:@"MMLibraryViewController.selectedPlaylistContentType: MUST be overriden by subclasses" userInfo: nil];
}

@end
