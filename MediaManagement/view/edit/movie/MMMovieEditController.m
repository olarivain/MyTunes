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
@property (nonatomic, readwrite, retain) MMContent *content;
@property (nonatomic, readwrite, retain) MMFieldView *genreFieldView;
@property (nonatomic, readwrite, retain) UIView *editView;
@end

@implementation MMMovieEditController

- (void) dealloc
{
  self.editView = nil;
  self.genreFieldView = nil;
  self.content = nil;
  [super dealloc];
}

@synthesize content;
@synthesize genreFieldView;
@synthesize editView;

- (void) setContent:(MMContent *) newContent
{
  if(newContent == content) {
    return;
  }
  
  [content release];
  content = [newContent retain];
  
  [genreFieldView setValue: content.genre];
}

- (void) updateContent
{
  content.genre = [genreFieldView stringValue];
}

@end
