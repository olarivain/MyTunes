//
//  DownloadQueueItem.m
//  ECUtil
//
//  Created by Kra on 6/28/11.
//  Copyright 2011 Kra. All rights reserved.
//

#import "MMRequestQueueItem.h"
#import "MMRequestQueue.h"

@interface MMRequestQueueItem()
@property (nonatomic, readwrite, weak) MMRequestQueue *queue;
@property (nonatomic, readwrite, strong) NSURL *url;
@property (nonatomic, readwrite, strong) NSURLConnection *connection;
@property (nonatomic, readwrite, strong) NSURLResponse *response;
@property (nonatomic, readwrite, strong) NSMutableData *responseData;
@property (nonatomic, readwrite, copy) RequestCallback callback;
@property (nonatomic, readwrite, assign) BOOL success;
@property (nonatomic, readwrite, strong) NSError *error;
@property (nonatomic, readwrite, strong) NSString *method;
@property (nonatomic, readwrite, strong) NSData *requestData;

- (id) initWithQueue: (MMRequestQueue*) downloadQueue URL: (NSURL*) downloadURL method: (NSString *) aMethod data: (NSData *) data andCallback:(RequestCallback) requestCallback;
- (NSHTTPURLResponse*) httpResponse;
@end

@implementation MMRequestQueueItem

+ (id) requestQueueItemWithQueue: (MMRequestQueue*) queue URL: (NSURL*) url andCallback:(RequestCallback) requestCallback 
{
  return [MMRequestQueueItem requestQueueItemWithQueue: queue URL: url method: @"GET" data: nil andCallback: requestCallback];
}

+ (id) requestQueueItemWithQueue: (MMRequestQueue*) queue URL: (NSURL*) url method: (NSString *) aMethod data: (NSData *) data andCallback:(RequestCallback) requestCallback 
{
  return [[MMRequestQueueItem alloc] initWithQueue: queue URL: url method: aMethod data: data andCallback: requestCallback];
}

- (id) initWithQueue: (MMRequestQueue*) downloadQueue URL: (NSURL*) downloadURL method: (NSString *) aMethod data: (NSData *) data andCallback:(RequestCallback) requestCallback 
{
  self = [super init];
  if(self) 
{
    self.url = downloadURL;
    self.requestData = data;
    self.method = aMethod;
    self.queue = downloadQueue;
    self.callback = requestCallback;
    self.responseData = [NSMutableData data];
  }
  
  return self;
}

- (void) dealloc 
{
  self.queue = nil;
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
@synthesize cancellationKey;

#pragma mark - Start/Stop methods
- (void) start 
{
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];;
  [request setHTTPBody: requestData];
  [request setHTTPMethod: method];
  
  self.connection = [NSURLConnection connectionWithRequest: request delegate: self];
  
  [connection start];
}

- (void) cancel 
{
  [connection cancel];
  CFRunLoopStop(CFRunLoopGetCurrent());
}

#pragma mark - JSON converter
- (NSObject*) jsonObject 
{
  NSObject *object = [NSJSONSerialization JSONObjectWithData: responseData options: NSJSONReadingAllowFragments error: nil];
  return object;
}

- (NSDictionary*) jsonDictionary 
{
  NSObject *object = [self jsonObject];
  if([object isKindOfClass: [NSDictionary class]])
{
      return (NSDictionary *) object;
  }
  
  return nil;
}

- (NSArray*) jsonArray 
{
  NSObject *object = [self jsonObject];
  if([object isKindOfClass: [NSArray class]])
{
      return (NSArray *) object;
  }
  
  return nil;
}

#pragma mark - HTTP convenience
- (BOOL) isSuccessful 
{
  // successful = no errors and http code in 200 range
  NSInteger status = [self status];
  return  error == nil && (199 < status) && (status < 300);
}

- (void) logFailure 
{
  if([self isSuccessful]) 
  {
    return;
  }
  NSLog(@"\n***\nCould not perform request:\n-Request URL: %@\n-HTTP Status Code: %i\n-Reason: %@\n-Description: %@\n***\n", url, [self status], [error localizedFailureReason], [error localizedDescription]);
}

- (NSInteger) status 
{
  NSHTTPURLResponse *httpResponse = [self httpResponse];
  if(httpResponse == nil)
  {
      return -1;
  }
     
  return [httpResponse statusCode];
}

- (NSDictionary*) headers 
{
  NSHTTPURLResponse *httpResponse = [self httpResponse];
  if(httpResponse == nil) 
  {
      return nil;
  }
  
  return [httpResponse allHeaderFields];
}

- (NSHTTPURLResponse*) httpResponse 
{
  if(response == nil) 
  {
      return nil;
  }
  
  if(![response isKindOfClass: [NSHTTPURLResponse class]])
  {
      return nil;
  }
  return (NSHTTPURLResponse*) response;
}

#pragma mark - NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse 
{
  self.response = aResponse;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)newData  
{
  [responseData appendData: newData];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection 
{
  success = YES;
#ifdef DEBUG
  [self logFailure];
#endif
  CFRunLoopStop(CFRunLoopGetCurrent());
  [queue requestFinished: self];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)failure 
{
  success = NO;
#ifdef DEBUG
  [self logFailure];
#endif
  self.error = failure;
  [queue requestFinished: self];
  CFRunLoopStop(CFRunLoopGetCurrent());
}

@end
