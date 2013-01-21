//
//  MMFieldView.h
//  MediaManagement
//
//  Created by Larivain, Olivier on 9/11/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMFieldView : UIView {
	IBOutlet UITextField *textView;
}

- (void) setValue: (id) value;
- (NSString *) stringValue;
- (NSNumber *) numberValue;

- (void) setInputAccessoryView: (UIView *) view;

@end
