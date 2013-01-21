//
//  NSNumber+NSNumber_NonZero.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 kra. All rights reserved.
//

#import "NSNumber+NonZero.h"

@implementation NSNumber (NSNumber_NonZero)

- (NSString *) nonZeroStringValue
{
	if([self floatValue] != 0)
	{
		return [self stringValue];
	}
	
	return @"";
}

@end
