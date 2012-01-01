//
//  MMTitleTrackSectionHeader.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 1/1/12.
//  Copyright (c) 2012 Edmunds. All rights reserved.
//

#import "MMTitleTrackSectionHeader.h"

static UIFont *font;
static UIColor *color;

@interface MMTitleTrackSectionHeader()
- (void) sharedInit;
@end


@implementation MMTitleTrackSectionHeader

- (id) initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder: aDecoder];
  if(self) {
    [self sharedInit];
  }
  return self;
}

- (id) initWithFrame:(CGRect)frame {
  self =[super initWithFrame: frame];
  if(self) {
    [self sharedInit];
  }
  return self;
}

- (void) sharedInit {
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    font = [UIFont fontWithName: @"Helvetica" size: 15.0f];
    color = [UIColor blackColor];
  });
  
  CGFloat margin = 10;
  CGRect labelFrame = CGRectMake(margin, 0, self.frame.size.width - margin, self.frame.size.height);
  label = [[UILabel alloc] initWithFrame:labelFrame];
  label.backgroundColor = [UIColor clearColor];
  // go with bold font by default, since that's what we'll want in most cases.
  label.font = font;
  
  label.textColor = color;
  label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self addSubview:label];
}

- (void) setTitle: (NSString *) title
{
  label.text = title;
}


@end
