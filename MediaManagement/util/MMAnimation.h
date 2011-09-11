//
//
//  Created by Kra on 7/9/11.
//  Copyright 2011 Kra. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^MMAnimationBlock)(void);
typedef void(^MMCompletionBlock)(BOOL);

#define EMPTY_COMPLETION ^(BOOL finished){}

#define SHORT_ANIMATION_DURATION 0.2
#define MEDIUM_ANIMATION_DURATION 0.35
#define LONG_ANIMATION_DURATION 0.5