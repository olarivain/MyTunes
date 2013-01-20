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
  __strong UIActivityIndicatorView *activityIndicator;
}

- (void) setLoading: (BOOL) loading;
- (void) setLoading: (BOOL) loading animated: (BOOL) animated;

@end
