//
//  MediaManagementAppDelegate.h
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMHomeViewController;

@interface MediaManagementAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet UINavigationController *viewController;

@end
