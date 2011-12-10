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

@interface MMMovieEditController()
@property (nonatomic, readwrite, strong) MMContent *content;
@property (nonatomic, readwrite, strong) MMFieldView *genreFieldView;
@property (nonatomic, readwrite, strong) UIView *editView;
@end

@implementation MMMovieEditController


@synthesize content;
@synthesize genreFieldView;
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
