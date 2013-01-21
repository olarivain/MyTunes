//
//  MMLibraryController.h
//  MediaManagement
//
//  Created by Kra on 5/15/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MYTServer;

@protocol MMLibraryViewController <NSObject>

@property (nonatomic, readwrite, strong) MYTServer *server;

@end
