//
//  HomeBackground.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeBackground.h"


@implementation HomeBackground

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
  // TODO: get the radial gradient to work
  CGRect frame = [self frame];
  CGContextRef contextRef = UIGraphicsGetCurrentContext();
  
  CGGradientRef gradient;

  size_t num_locations = 2;
  CGFloat locations[2] = { 0.0, 1.0 };
  CGFloat components[8] = { 1.0, 1.0, 1.0, 1.0,  // Start color
    0.0, 0.0, 1.0, 1.0 }; // End color
  
//  CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
  gradient = CGGradientCreateWithColorComponents (NULL, components,
                                                    locations, num_locations);  
  CGPoint start = CGPointMake(frame.size.width / 2, frame.size.height / 2);
  
  CGContextDrawRadialGradient(contextRef, gradient, start, frame.size.width / 4, start, frame.size.width / 2, kCGGradientDrawsAfterEndLocation);

}


- (void)dealloc
{
    [super dealloc];
}

@end
