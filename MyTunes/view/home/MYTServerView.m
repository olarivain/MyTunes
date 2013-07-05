//
//  ServerIcon.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MYTServerView.h"

#import "MYTServer.h"

@interface MYTServerView()
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic) UIColor *initialColor;
@end

@implementation MYTServerView


- (void) awakeFromNib
{
	self.layer.cornerRadius = 20;
    self.initialColor = self.backgroundColor;
}

#pragma  mark - Server management;
- (void) updateWithServer:(MYTServer *)server
{
	self.label.text = server.name;
}

- (void) setHighlighted:(BOOL)highlighted {
    self.backgroundColor = highlighted ? [UIColor darkGrayColor] : self.initialColor;
}

- (void) setSelected:(BOOL)selected {
    self.backgroundColor = selected ? [UIColor darkGrayColor] : self.initialColor;    
}

@end
