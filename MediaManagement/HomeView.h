//
//  HomeBackground.h
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomeView : UIView 
{    
  @private
  NSArray *servers;
  
  NSMutableArray *serverViews;
}

@property (readwrite, retain) NSArray *servers;
@property (readonly) NSArray *serverViews;

@end
