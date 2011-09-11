//
//  MMContentPlacholder.m
//  MediaManagement
//
//  Created by Kra on 6/1/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMContentPlacholder.h"

@interface MMContentPlacholder()
@property (nonatomic, readwrite, retain) UIView *contentEditView;
@end

@implementation MMContentPlacholder

- (void)dealloc
{
  self.contentEditView = nil;
  [super dealloc];
}

@synthesize contentEditView;

- (void) setEditView:(UIView *)editView
{
  if(editView == contentEditView) {
    return;
  }
  
  [contentEditView removeFromSuperview];
  [contentEditView release];
  
  contentEditView = [editView retain];
  [self addSubview: contentEditView];
  
  CGRect frame = contentEditView.frame;
  frame.origin = CGPointZero;
  
  contentEditView.frame = frame;
}

@end
