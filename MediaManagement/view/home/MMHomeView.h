//
//  HomeBackground.h
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMServerView;

@interface MMHomeView : UIView 
{    
  @private
  NSArray *servers;
  NSMutableArray *serverViews;
  
  IBOutlet MMServerView *serverView;
}

@property (readwrite, retain) NSArray *servers;
@property (readonly) NSArray *serverViews;

@end
