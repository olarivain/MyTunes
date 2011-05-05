//
//  BaseMainViewController.h
//  MediaManagement
//
//  Created by Kra on 3/9/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMServer;
@class MMContentRepository;

@interface BaseMainViewController : NSObject 
{
  MMServer *server;
  MMContentRepository *repository;
}

@property (nonatomic, readwrite, retain) MMServer *server;
@property (nonatomic, readwrite, retain) MMContentRepository *repository;

@end
