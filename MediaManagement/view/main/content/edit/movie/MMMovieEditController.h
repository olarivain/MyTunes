//
//  MMMovieEditController.h
//  MediaManagement
//
//  Created by Larivain, Olivier on 9/11/11.
//  Copyright 2011 Edmunds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMContentEditController.h"

@class MMFieldView;
@class MMContent;

@interface MMMovieEditController : NSObject<MMContentEditController>
{
  __strong MMContent *content;

  IBOutlet __strong MMFieldView *genreFieldView;
  IBOutlet __strong UIView *editView;
}

@property (nonatomic, readwrite, strong) UIView *editView;

@end
