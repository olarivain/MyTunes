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
  MMContent *content;
  IBOutlet MMFieldView *genreFieldView;
  IBOutlet UIView *editView;
}

@end
