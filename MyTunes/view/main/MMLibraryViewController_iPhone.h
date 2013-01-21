//
//  MainViewController_iPhone.h
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMLibraryViewController.h"

@interface MMLibraryViewController_iPhone : UIViewController<MMLibraryViewController>
{
  __strong MYTServer *server;
}

@property (nonatomic, readwrite, strong) MYTServer *server;


@end
