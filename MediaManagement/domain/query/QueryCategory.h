//
//  QueryCategory.h
//  MediaManagement
//
//  Created by Kra on 3/9/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Content.h"

@interface QueryCategory : NSObject 
{
  ContentKind kind;
  NSString *name;
  NSMutableArray *queries;
}

@property (nonatomic, readwrite, assign) ContentKind kind;
@property (nonatomic, readwrite, assign) NSArray *queries;

@end
