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

@property (strong, nonatomic, readwrite) MMContent *content;
@property (strong, nonatomic, readwrite) NSArray *contentList;
@property (strong, nonatomic, readwrite) KCVoidBlock completion;

@end
