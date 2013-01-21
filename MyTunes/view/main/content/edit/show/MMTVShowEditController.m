//
//  MMTVShowEditView.m
//  MediaManagement
//
//  Created by Kra on 6/1/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <MediaManagement/MMContent.h>

#import "MMTVShowEditController.h"
#import "MMFieldView.h"

@implementation MMTVShowEditController

- (void) awakeFromNib
{
	showField.inputAccessoryView = previousNextToolbar;
	episodeField.inputAccessoryView = previousNextToolbar;
	seasonField.inputAccessoryView = previousNextToolbar;
}

@synthesize editView;

- (void) setContent: (MMContent*) newContent
{
	if(newContent == content) {
		return;
	}
	
	content = newContent;
	
	[showField setValue: content.show];
	[episodeField setValue: content.episodeNumber];
	[seasonField setValue: content.season];
}

- (void) updateContent
{
	
	content.show = [showField stringValue];
	content.episodeNumber = [episodeField numberValue];
	content.season = [seasonField numberValue];
}

@end
