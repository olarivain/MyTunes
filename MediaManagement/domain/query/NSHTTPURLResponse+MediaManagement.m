//
//  NSHTTPURLResponse+MediaManagement.m
//  MediaManagement
//
//  Created by Kra on 5/4/11.
//  Copyright 2011 kra. All rights reserved.
//

#import "NSHTTPURLResponse+MediaManagement.h"


@implementation NSHTTPURLResponse (NSHTTPURLResponse_MediaManagement)

- (BOOL) isValid
{
  NSInteger statusCode = [self statusCode];
  return (statusCode > 199 || statusCode < 300);
}


- (NSStringEncoding) contentEncoding
{
  NSString *encodingString = [[self allHeaderFields] objectForKey:@"Content-Encoding"];
  if([encodingString caseInsensitiveCompare:@"UTF-8"])
  {
    return NSUTF8StringEncoding;
  }
  
  if([[encodingString uppercaseString] hasPrefix:@"ISO 8859"])
  {
    return NSISOLatin1StringEncoding;
  }
  
  return NSUTF8StringEncoding;
}


@end
