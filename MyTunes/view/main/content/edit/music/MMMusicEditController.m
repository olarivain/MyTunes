//
//  MyClass.m
//  MediaManagement
//
//  Created by Kra on 6/1/11.
//  Copyright 2011 kra. All rights reserved.
//
#import <MediaManagement/MMContent.h>
#import "MMMusicEditController.h"
#import "MMFieldView.h"

@interface MMMusicEditController()
@end

@implementation MMMusicEditController

- (void) awakeFromNib
{
	albumField.inputAccessoryView = previousNextToolbar;
	artistField.inputAccessoryView = previousNextToolbar;
	trackNumberField.inputAccessoryView = previousNextToolbar;
}

@synthesize editView;

- (void) dealloc
{
	content = nil;
}

- (void) setContent:(MMContent *) newContent
{
	if(newContent == content) {
		return;
	}
	
	content = newContent;
	
	[albumField setValue: content.album];
	[artistField setValue: content.artist];
	[trackNumberField setValue: content.trackNumber];
	[genreField setValue: content.genre];
}

- (void) updateContent
{
	content.album = [albumField stringValue];
	content.artist = [artistField stringValue];
	content.trackNumber = [trackNumberField numberValue];
	content.genre = [genreField stringValue];
}

@end
