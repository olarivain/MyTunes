//
//  HomeBackground.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMHomeView.h"


@interface MMHomeView()
@end

@implementation MMHomeView

#pragma mark - Layout
- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 1.0 };
	CGFloat components[8] = { 0.0, 0.35, .7, 1.0,
		0.0, 0.0, 0.39f, 1.0 };
	CGGradientRef gradient = CGGradientCreateWithColorComponents (colorSpace, components,
																  locations, num_locations);
	
	CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
	CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
	CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsAfterEndLocation );
	
	CFRelease(gradient);
	CFRelease(colorSpace);
}

@end
