//
//  DownloadQueueItem.m
//  ECUtil
//
//  Created by Kra on 6/28/11.
//  Copyright 2011 Kra. All rights reserved.
//

#import "MMRequestQueueItem.h"
#import "MMRequestQueue.h"

#import "JSONKit.h"

@interface MMRequestQueueItem()
@property (nonatomic, readwrite, assign) MMRequestQueue *queue;
@property (nonatomic, readwrite, retain) NSURL *url;
@property (nonatomic, readwrite, retain) NSURLConnection *connection;
@property (nonatomic, readwrite, retain) NSURLResponse *response;
@property (nonatomic, readwrite, retain) NSMutableData *responseData;
@property (nonatomic, readwrite, copy) RequestCallback callback;
@property (nonatomic, readwrite, assign) BOOL success;
@property (nonatomic, readwrite, retain) NSError *error;
@property (nonatomic, readwrite, retain) NSString *method;
@property (nonatomic, readwrite, retain) NSData *requestData;

- (id) initWithQueue: (MMRequestQueue*) downloadQueue URL: (NSURL*) downloadURL method: (NSString *) aMethod data: (NSData *) data andCallback:(RequestCallback) requestCallback;
- (NSHTTPURLResponse*) httpResponse;
@end

@implementation MMRequestQueueItem

+ (id) requestQueueItemWithQueue: (MMRequestQueue*) queue URL: (NSURL*) url andCallback:(RequestCallback) requestCallback {
  return [MMRequestQueueItem requestQueueItemWithQueue: queue URL: url method: @"GET" data: nil andCallback: requestCallback];
}

+ (id) requestQueueItemWithQueue: (MMRequestQueue*) queue URL: (NSURL*) url method: (NSString *) aMethod data: (NSData *) data andCallback:(RequestCallback) requestCallback {
  return [[[MMRequestQueueItem alloc] initWithQueue: queue URL: url method: aMethod data: data andCallback: requestCallback] autorelease];
}

- (id) initWithQueue: (MMRequestQueue*) downloadQueue URL: (NSURL*) downloadURL method: (NSString *) aMethod data: (NSData *) data andCallback:(RequestCallback) requestCallback {
  self = [super init];
  if(self) {
    self.url = downloadURL;
    self.requestData = data;
    self.method = aMethod;
    self.queue = downloadQueue;
    self.callback = requestCallback;
    self.responseData = [NSMutableData data];
  }
  
  return self;
}

- (void) dealloc {
  self.url = nil;
  self.requestData = nil;
  self.callback = nil;
  self.queue = nil;
  self.connection = nil;
  self.responseData = nil;
  self.error = nil;
  self.response = nil;
  self.method = nil;
  [super dealloc];
}

@synthesize url;
@synthesize callback;
@synthesize responseData;
@synthesize connection;
@synthesize queue;
@synthesize success;
@synthesize error;
@synthesize response;
@synthesize cancelledInCallbackPhase;
@synthesize requestData;
@synthesize method;

#pragma mark - Start/Stop methods
- (void) start {
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];;
  [request setHTTPBody: requestData];
  NSLog(@"content is: %i", [requestData length]);
  [request setHTTPMethod: method];
  
  self.connection = [NSURLConnection connectionWithRequest: request delegate: self];
  
#if DEBUG_NETWORK==1
  NSLog(@"starting connection to %@", [url absoluteString]);
#endif
  [connection start];
}

- (void) cancel {
  [connection cancel];
  CFRunLoopStop(CFRunLoopGetCurrent());
}

#pragma mark - JSON converter
- (NSObject*) jsonObject {
  JSONDecoder *decoder = [JSONDecoder decoderWithParseOptions: JKParseOptionLooseUnicode];
  NSObject *object = [decoder objectWithData: responseData];
  return object;
}

- (NSDictionary*) jsonDictionary {
  NSObject *object = [self jsonObject];
  if([object isKindOfClass: [NSDictionary class]]){
      return (NSDictionary *) object;
  }
  
  return nil;
}

- (NSArray*) jsonArray {
  NSObject *object = [self jsonObject];
  if([object isKindOfClass: [NSArray class]]){
      return (NSArray *) object;
  }
  
  return nil;
}

#pragma mark - HTTP convenience
- (NSInteger) status {
  NSHTTPURLResponse *httpResponse = [self httpResponse];
  if(httpResponse == nil) {
      return -1;
  }
     
  return [httpResponse statusCode];
}

- (NSDictionary*) headers {
  NSHTTPURLResponse *httpResponse = [self httpResponse];
  if(httpResponse == nil) {
      return nil;
  }
  
  return [httpResponse allHeaderFields];
}

- (NSHTTPURLResponse*) httpResponse {
  if(response == nil) {
      return nil;
  }
  
  if(![response isKindOfClass: [NSHTTPURLResponse class]]){
      return nil;
  }
  return (NSHTTPURLResponse*) response;
}

#pragma mark - NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse {
  self.response = aResponse;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)newData  {
  [responseData appendData: newData];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
#if DEBUG_NETWORK==1
  NSLog(@"connetion finished");
#endif
  success = YES;
  CFRunLoopStop(CFRunLoopGetCurrent());
  [queue requestFinished: self];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)failure {
  
#if DEBUG_NETWORK==1
  NSLog(@"connetion failed with error %@", failure);
#endif
  
  success = NO;
  self.error = failure;
  [queue requestFinished: self];
  CFRunLoopStop(CFRunLoopGetCurrent());
}

@end
