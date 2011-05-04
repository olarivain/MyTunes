//
//  QueryCategory.h
//  MediaManagement
//
//  Created by Kra on 3/9/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MediaManagement/MMContent.h>

@interface QueryCategory : NSObject 
{
  MMContentKind kind;
  NSString *name;
  NSMutableArray *queries;
}

@property (nonatomic, readwrite, assign) MMContentKind kind;
@property (nonatomic, readwrite, assign) NSArray *queries;

@end
