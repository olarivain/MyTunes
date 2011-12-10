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
  
  IBOutlet MMServerView *__weak serverView;
}

@property (nonatomic, readwrite, strong) NSArray *servers;
@property (nonatomic, readonly, strong) NSArray *serverViews;

@end
