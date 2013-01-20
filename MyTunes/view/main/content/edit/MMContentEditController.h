//
//  MMContentEditController.h
//  MediaManagement
//
//  Created by Kra on 6/1/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMContent;

@protocol MMContentEditController <NSObject>

- (void) setContent: (MMContent*) content;
- (void) updateContent;

@property(nonatomic, readonly) UIView *editView;

@end
