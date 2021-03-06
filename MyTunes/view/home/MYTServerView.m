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
@property (nonatomic, readwrite, weak) IBOutlet UILabel *label;
@end

@implementation MYTServerView


- (void) awakeFromNib
{
	self.layer.cornerRadius = 20;
}

#pragma  mark - Server management;
- (void) updateWithServer:(MYTServer *)server
{
	self.label.text = server.name;
}

@end
