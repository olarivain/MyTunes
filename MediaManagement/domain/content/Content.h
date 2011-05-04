//
//  Content.h
//  MediaManagement
//
//  Created by Kra on 3/9/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum ContentKind{
  MUSIC = 0,
  MOVIE = 1,
  TV_SHOW = 2,
  PODCAST = 3,
  ITUNES_U = 4,
  UNKNOWN = 5;
}ContentKind;

@interface Content : NSObject {
  @private
  NSString *name;
  NSString *description;
  NSString *genre;
  UIImage *thumbnail;
  
  ContentKind kind;
  
  NSString *show;
  NSInteger order;
  NSInteger season;

}

@property (nonatomic, readwrite, retain) NSString *name;
@property (nonatomic, readwrite, retain) NSString *show;
@property (nonatomic, readwrite, retain) NSString *description;
@property (nonatomic, readwrite, retain) NSString *genre;
@property (nonatomic, readwrite, retain) UIImage *thumbnail;
@property (nonatomic, readwrite, assign) NSInteger order;
@property (nonatomic, readwrite, assign) NSInteger season;
@property (nonatomic, readwrite, assign) ContentKind kind;
@end
