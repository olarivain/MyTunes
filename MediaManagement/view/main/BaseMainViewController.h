//
//  BaseMainViewController.h
//  MediaManagement
//
//  Created by Kra on 3/9/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Server;
@class ContentRepository;

@interface BaseMainViewController : NSObject 
{
  Server *server;
  ContentRepository *repository;
}

@property (nonatomic, readwrite, retain) Server *server;
@property (nonatomic, readwrite, retain) ContentRepository *repository;

@end
