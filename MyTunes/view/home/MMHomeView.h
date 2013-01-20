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
  __strong NSArray *servers;
  __strong NSMutableArray *serverViews;
  
  IBOutlet __weak MMServerView *serverView;
}

@property (nonatomic, readwrite, strong) NSArray *servers;
@property (nonatomic, readonly) NSArray *serverViews;

@end
