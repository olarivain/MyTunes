//
//  MMLoadingView.h
//  MediaManagement
//
//  Created by Kra on 6/1/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MMLoadingView : UIView 
{
  UIActivityIndicatorView *activityIndicator;
}

- (void) setLoading: (BOOL) loading;

@end
