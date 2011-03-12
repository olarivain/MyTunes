//
//  ContentQuery.h
//  MediaManagement
//
//  Created by Kra on 3/9/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QueryCategory;
typedef enum QueryType{
  RECENT = 0
} QueryType;

@interface Query : NSObject 
{ 
  QueryType type;
  QueryCategory *category;
}

@property (nonatomic, readwrite, assign) QueryType type;
@property (nonatomic, readwrite, retain) QueryCategory *category;

@end
