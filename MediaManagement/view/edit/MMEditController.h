//
//  EditController.h
//  MediaManagement
//
//  Created by Kra on 3/7/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaManagement/MMContent.h>

@class MMContentGroup;
@class MMPlaylist;
@class MMLoadingView;

@protocol MMEditControllerDelegate <NSObject>

- (void) didEditContent: (MMContent *) item;

@end

@interface MMEditController : UIViewController 
{
  MMPlaylist *playlist;
  MMContentGroup *contentGroup;
  MMContent *currentItem;
  NSArray *contentList;
  NSUInteger currentIndex;
  
  IBOutlet UIBarButtonItem *next;
  IBOutlet UIBarButtonItem *previous;
  IBOutlet MMLoadingView *loadingView;
  IBOutlet __weak id<MMEditControllerDelegate> delegate;
  
  MMContentKind currentKind;
}

@property (nonatomic, readwrite, strong) MMPlaylist *playlist;
@property (nonatomic, readwrite, strong) MMContentGroup *contentGroup;
@property (nonatomic, readwrite, strong) MMContent *currentItem;
@property (nonatomic, readwrite, weak) id<MMEditControllerDelegate> delegate;

- (IBAction) save: (id) sender;
- (IBAction) cancel: (id) sender;
- (void) dismiss;

@end
