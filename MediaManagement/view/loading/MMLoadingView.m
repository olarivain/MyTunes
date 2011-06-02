//
//  MMLoadingView.m
//  MediaManagement
//
//  Created by Kra on 6/1/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMLoadingView.h"


@implementation MMLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
      activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
      [self addSubview: activityIndicator];
      
      CGSize frameSize = frame.size;
      CGPoint center = CGPointMake(frameSize.width / 2, frameSize.height / 2);
      activityIndicator.center = center;
      activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    return self;
}

- (void)dealloc
{
  [activityIndicator release];
  [super dealloc];
}

- (void) setLoading: (BOOL) loading
{
  if(loading)
  {
    [activityIndicator startAnimating];
  }
  else 
  {
    [activityIndicator stopAnimating];
  }
  
  CGFloat alpha = loading ? 1 : 0;
  [UIView animateWithDuration: 0.2 animations:^(void) {
    self.alpha = alpha;
  }];
}

@end
