//
//  ContentView.h
//  MediaManagement
//
//  Created by Kra on 5/15/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MMContentView : UIView 
{
  IBOutlet UIView *loadingLayer;
  IBOutlet UIActivityIndicatorView *activityIndicator;
}

- (void) setLoading: (BOOL) loading;

@end
