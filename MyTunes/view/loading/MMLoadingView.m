//
//  MMLoadingView.m
//  MediaManagement
//
//  Created by Kra on 6/1/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <KraCommons/KCAnimation.h>
#import "MMLoadingView.h"

@interface MMLoadingView()
@property (nonatomic, strong, readwrite) UIActivityIndicatorView *activityIndicator;
@end

@implementation MMLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
		[self sharedInit];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder: aDecoder];
	if(self)
	{
		[self sharedInit];
	}
	return self;
}

- (void) sharedInit
{
	self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
	[self addSubview: self.activityIndicator];
	
	CGSize frameSize = self.frame.size;
	CGPoint center = CGPointMake(frameSize.width / 2, frameSize.height / 2);
	self.activityIndicator.center = center;
	self.activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
}

- (void) setLoading:(BOOL)loading
{
	[self setLoading: loading animated: NO];
}

- (void) setLoading: (BOOL) loading animated:(BOOL)animated
{
	if(loading)
	{
		[self.superview bringSubviewToFront: self];
		[self.activityIndicator startAnimating];
	}
	else
	{
		[self.activityIndicator stopAnimating];
		[self.superview sendSubviewToBack: self];
	}
	
	CGFloat alpha = loading ? 1 : 0;
	if(animated)
	{
		KCAnimationBlock animation = ^{
			self.alpha = alpha;
		};
		[UIView animateWithDuration: SHORT_ANIMATION_DURATION animations: animation];
	}
	else
	{
		self.alpha = alpha;
	}
}

@end
