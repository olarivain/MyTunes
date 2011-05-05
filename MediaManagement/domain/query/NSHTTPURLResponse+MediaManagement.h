//
//  NSHTTPURLResponse+MediaManagement.h
//  MediaManagement
//
//  Created by Kra on 5/4/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSHTTPURLResponse (NSHTTPURLResponse_MediaManagement)
- (BOOL) isValid;
- (NSStringEncoding) contentEncoding;
@end
