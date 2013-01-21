//
//  MMContentPlacholder.m
//  MediaManagement
//
//  Created by Kra on 6/1/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMContentPlacholder.h"

@interface MMContentPlacholder()
@property (nonatomic, readwrite, strong) UIView *contentEditView;
@end

@implementation MMContentPlacholder


@synthesize contentEditView;

- (void) setEditView:(UIView *)editView
{
	if(editView == contentEditView) {
		return;
	}
	
	[contentEditView removeFromSuperview];
	
	contentEditView = editView;
	[self addSubview: contentEditView];
	
	CGRect frame = contentEditView.frame;
	frame.origin = CGPointZero;
	frame.size = self.frame.size;
	
	contentEditView.frame = frame;
}

@end
