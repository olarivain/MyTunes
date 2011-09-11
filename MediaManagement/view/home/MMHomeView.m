//
//  HomeBackground.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "MMHomeView.h"
#import "MMServerView.h"
#import "NibUtils.h"

#define MARGIN 40
#define PADDING 20

@interface MMHomeView()

@property (nonatomic, readwrite, retain) NSArray *serverViews;
@property (nonatomic, readwrite, assign) MMServerView *serverView;

- (void) removeLastServerIcons: (int) count;
- (void) addServerView: (int) count;
- (int) computeServerPerRows;
- (int) computePaddingWith: (int) countPerRow;
@end

@implementation MMHomeView

- (id) initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder: aDecoder];
  if(self)
  {
    serverViews = [[NSMutableArray alloc] init];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
      serverViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
  self.servers = nil;
  self.serverView = nil;
  self.serverViews = nil;
  
  [super dealloc];
}

@synthesize serverView;
@synthesize serverViews;

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


- (void) layoutSubviews
{
  [super layoutSubviews];
  if([serverViews count] == 0)
  {
    return;
  }
  
  int numberOfViewsPerRow = [self computeServerPerRows];
  int count = 0;
  int line = 0;
  int xPosition = MARGIN;
  int yPosition = MARGIN;
  int highestView = -1;
  
  int padding = [self computePaddingWith: numberOfViewsPerRow];
  
  for(MMServerView *view in serverViews)
  {
    if(count == numberOfViewsPerRow)
    {
      xPosition = MARGIN;
      yPosition += highestView + MARGIN;
      highestView = 0;
      count = 0;
      line++;
    }

    CGRect frame = [view frame];
    frame.origin.x = xPosition;
    frame.origin.y = yPosition;
    [view setFrame: frame];
    
    xPosition += frame.size.width + padding;
    if(frame.size.height > highestView)
    {
      highestView = frame.size.height;
    }
    
    count++;
  }
}

- (int) computeServerPerRows
{
  double actualWidth = [self frame].size.width - 2*MARGIN;
  
  MMServerView *view = [serverViews objectAtIndex: 0];
  double viewWidth = [view frame].size.width;
  
  int numberOfViewPerRow = (actualWidth - PADDING) / (viewWidth + PADDING);
  return numberOfViewPerRow;
}

- (int) computePaddingWith: (int) countPerRow
{
  double actualWidth = [self frame].size.width - 2*MARGIN;
  
  MMServerView *view = [serverViews objectAtIndex: 0];
  double viewWidth = [view frame].size.width;

  double remaining = actualWidth - countPerRow * viewWidth;
  return remaining / (countPerRow - 1);
}

#pragma mark - Server views management
- (NSArray*) servers
{
  return servers;
}

- (void) setServers:(NSArray *) newServers
{
  [newServers retain];
  [servers release];
  servers = newServers;

  
  int diff = [servers count] - [serverViews count];
  if(diff < 0)
  {
    [self removeLastServerIcons: -diff];
  }
  if(diff > 0)
  {
    [self addServerView:diff];
  }
  
  for(int i = 0; i < [servers count]; i++)
  {
    MMServer *server = [servers objectAtIndex:i];
    MMServerView *icon = [serverViews objectAtIndex: i];
    icon.server = server;
    [icon update];
  }
  
  [self setNeedsLayout];
}

#pragma mark Subview Add/Removal
- (void) removeLastServerIcons: (int) count
{
  for(int i = 0; i < count; i++)
  {
    MMServerView *icon = [serverViews lastObject];
    [icon removeFromSuperview];
    [serverViews removeLastObject];
  }

}
- (void) addServerView: (int) count
{
  for(int i = 0; i < count; i++)
  {
    NSString *nibName = [NibUtils nibName:@"MMServerView"];
    [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    CGRect rect = [serverView frame];
    rect.origin.x = 10;
    rect.origin.y = 10;
    [serverView setFrame: rect];
    [self addSubview: serverView];
    [serverViews addObject: serverView];
    self.serverView = nil;
  }
}

@end
