//
//  ECDownloadService.m
//  ECUtil
//
//  Created by Kra on 6/29/11.
//  Copyright 2011 Kra. All rights reserved.
//

#import "JSONKit.h"
#import "MMRequestDelegate.h"

#import "MMRequestQueueItem.h"
#import "MMServer.h"

@interface MMRequestDelegate()
@property(nonatomic, readwrite, assign) MMServer *server;
@end

@implementation MMRequestDelegate
+ (id) delegateWithServer: (MMServer *) baseServer {
  return [[[MMRequestDelegate alloc] initWithServer: baseServer] autorelease];
}

- (id) initWithServer: (MMServer *) base {
  self = [super init];
  if(self) {
      self.server = base;
  }
  return self;
}

- (void) dealloc {
  self.server = nil;
  [super dealloc];
}

@synthesize server;

#pragma mark - Convenience method
- (NSString *) paramString: (NSDictionary*) params {
  if(params == nil || [params count] == 0) {
      return @"";
  }
  
  NSMutableString *paramString = [NSMutableString stringWithString:@"?"];
  NSArray *allKeys = [params allKeys];
  for(NSString *key in allKeys) {
    id value = [params objectForKey: key];
    // we have a number, make sure we grab the string representation
    if([value isKindOfClass: [NSNumber class]]) {
      value = [(NSNumber *) value stringValue];
    } 
    
    // escape the string if possible
    if([value respondsToSelector:@selector(stringByAddingPercentEscapesUsingEncoding:)]){
      value = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    [paramString appendFormat:@"%@=%@", key, value];
    if(key != [allKeys lastObject]) {
      [paramString appendString:@"&"];
    }
  }
  return paramString;
}

#pragma mark - Request methods
- (MMRequestQueueItem*) requestWithPath: (NSString *) path andCallback: (RequestCallback) callback{
  return [self requestWithPath: path params: nil andCallback: callback];
}

- (MMRequestQueueItem*) requestWithPath: (NSString *) path params: (NSDictionary *) params andCallback: (RequestCallback) callback {
  return [self requestWithPath: path params: params method: @"GET" andCallback: callback];
}

- (MMRequestQueueItem*) requestWithPath: (NSString *) path params: (NSDictionary *) params method: (NSString *) method andCallback: (RequestCallback) callback
{
  NSString *urlString = [NSString stringWithFormat:@"%@%@", [server serverURL], path];

  NSData *data = nil;
  // process parameters appropriately, depending on requested method
  if([@"GET" isEqualToString: method]) {
    NSString *paramString = [self paramString: params];
    if(paramString) {
        urlString = [NSString stringWithFormat:@"%@%@", urlString, paramString];
    } 
  }
  else {
    data = [params JSONData];
  }

  // and schedule the guy
#if DEBUG_NETWORK==1
  NSLog(@"Scheduling for request:\n%@", urlString);
#endif
  NSURL *url = [NSURL URLWithString: urlString];
  return [MMRequestQueue scheduleURL: url withData: data withMethod: method andCallback: callback];
}

@end
