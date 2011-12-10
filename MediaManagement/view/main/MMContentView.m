//
//  ContentView.m
//  MediaManagement
//
//  Created by Kra on 5/15/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMContentView.h"

#import "MMAnimation.h"


@interface MMContentView()
@property (nonatomic, readwrite, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, readwrite, strong) UIView *loadingLayer;
@end

@implementation MMContentView


@synthesize loadingLayer;
@synthesize activityIndicator;

#pragma mark - Loading activity
- (void) setLoading: (BOOL) loading
{
  // animation blocks
  MMAnimationBlock animation = ^{
    loadingLayer.hidden = !loading;
  };
  
  MMCompletionBlock completion = ^(BOOL finished){
    if(loading)
    {
      [activityIndicator startAnimating]; 
    }
    else 
    {
      [activityIndicator stopAnimating];
    }
    activityIndicator.hidden = !loading;
  };
  
  // we have to bring to front and send back when we're done
  if(loading)
  {
    [self bringSubviewToFront: loadingLayer];
  }
  else
  {
    [self sendSubviewToBack: loadingLayer];
  }
  
  // now animate shit around
  [UIView animateWithDuration: SHORT_ANIMATION_DURATION animations: animation completion: completion];   
}

@end
