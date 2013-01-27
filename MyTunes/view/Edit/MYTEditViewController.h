//
//  MYTContentEditViewController.h
//  MyTunes
//
//  Created by Olivier Larivain on 1/21/13.
//
//

#import <UIKit/UIKit.h>

@class MMContent;

@interface MYTEditViewController : UIViewController


@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic, readwrite) NSArray *contentList;
@property (strong, nonatomic, readwrite) KCBooleanBlock dismissBlock;

@end
