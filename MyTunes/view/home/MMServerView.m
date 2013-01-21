//
//  ServerIcon.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MMServerView.h"

#import "MMServer.h"

@interface MMServerView()
@property (nonatomic, readwrite, weak) IBOutlet UILabel *label;
@end

@implementation MMServerView


- (void) awakeFromNib
{
	self.layer.cornerRadius = 20;
}

#pragma  mark - Server management;
- (void) updateWithServer:(MMServer *)server
{
	self.label.text = server.name;
}

@end
