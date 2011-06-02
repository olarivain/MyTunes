//
//  MMContentPlacholder.m
//  MediaManagement
//
//  Created by Kra on 6/1/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMContentPlacholder.h"


@implementation MMContentPlacholder

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void) setEditView:(UIView *)editView
{
  [contentEditView removeFromSuperview];
  contentEditView = editView;
  [self addSubview: contentEditView];
  
  CGRect frame = contentEditView.frame;
  frame.origin = CGPointZero;
  
  contentEditView.frame = frame;
}

@end
