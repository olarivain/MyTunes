//
//  MMMovieEditController.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 9/11/11.
//  Copyright 2011 Edmunds. All rights reserved.
//

#import <MediaManagement/MMContent.h>

#import "MMMovieEditController.h"

#import "MMFieldView.h"

@implementation MMMovieEditController

@synthesize editView;

- (void) setContent:(MMContent *) newContent
{
  if(newContent == content) {
    return;
  }
  
  content = newContent;
  
  [genreFieldView setValue: content.genre];
}

- (void) updateContent
{
  content.genre = [genreFieldView stringValue];
}

@end
