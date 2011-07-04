//
//  ECDownloadService.m
//  ECUtil
//
//  Created by Kra on 6/29/11.
//  Copyright 2011 Kra. All rights reserved.
//

#import "MMRequestDelegate.h"

#import "MMRequestQueueItem.h"
#import "MMServer.h"
#import "NSHTTPURLResponse+MediaManagement.h"

@interface MMRequestDelegate()
@property(nonatomic, readwrite, retain) MMServer *server;
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
        return nil;
    }
    
    NSMutableString *paramString = [NSMutableString stringWithString:@"?"];
    NSArray *allKeys = [params allKeys];
    for(NSString *key in allKeys) {
        NSString *value = [params objectForKey: key];
        [paramString appendFormat:@"%@=%@", key, [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if(key != [allKeys lastObject]) {
            [paramString appendString:@"&"];
        }
    }
    return paramString;
}

#pragma mark - Request methods
- (MMRequestQueueItem*) requestWithPath: (NSString *) path andCallback: (DownloadCallback) callback{
    return [self requestWithPath: path params: nil andCallback: callback];
}

- (MMRequestQueueItem*) requestWithPath: (NSString *) path params: (NSDictionary *) params  andCallback: (DownloadCallback) callback{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", [server serverURL], path];
    NSString *paramString = [self paramString: params];
    if(paramString) {
        urlString = [NSString stringWithFormat:@"%@%@", urlString, paramString];
    }
    
    NSURL *url = [NSURL URLWithString: urlString];
    return [MMRequestQueue scheduleURL: url withCallback: callback];
}

- (MMRequestQueueItem*) requestWithPath: (NSString *) path data: (NSData *) data andCallback: (DownloadCallback) callback
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", [server serverURL], path];
    NSURL *url = [NSURL URLWithString: urlString];
    
    return [MMRequestQueue scheduleURL: url withData: data andCallback: callback];
}

@end
