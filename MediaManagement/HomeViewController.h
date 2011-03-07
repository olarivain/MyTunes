//
//  MediaManagementViewController.h
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeTableViewDelegate;

@interface HomeViewController : UIViewController 
{
  @private
  IBOutlet HomeTableViewDelegate *tableViewDelegate;
}

@end
