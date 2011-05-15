//
//  ContentView.m
//  MediaManagement
//
//  Created by Kra on 5/15/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMContentView.h"


@interface MMContentView()
@property (nonatomic, readwrite, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, readwrite, retain) UIView *loadingLayer;
@end

@implementation MMContentView

- (void)dealloc
{
  self.loadingLayer = nil;
  self.activityIndicator = nil;
  [super dealloc];
}

@synthesize loadingLayer;
@synthesize activityIndicator;

#pragma mark - Loading activity
- (void) setLoading: (BOOL) loading
{
  void(^animation)(void) = ^{
    loadingLayer.hidden = !loading;
  };
  
  void(^completion)(BOOL finished) = ^(BOOL finished){
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
  
  [UIView animateWithDuration: 0.2 animations: animation completion: completion];
   
  }

@end
