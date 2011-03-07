//
//  Servers.m
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Servers.h"
#import "Server.h"


@implementation Servers

- (id) init
{
  self = [super init];
  if(self)
  {
    netService = [[NSNetService alloc]  initWithDomain:@"local." type:@"_http._tcp." name:@"iServe"];
    [netService setDelegate: self];
    servers = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void) dealloc
{
  [netService stop];
  [netService release];
  
  [servers release];
  [self dealloc];
}

@synthesize servers;
@synthesize delegate;

#pragma mark - Server access methods
- (void) refreshServerList
{
  [netService resolveWithTimeout:5];
}

- (Server*) serverAtIndexPath:(NSIndexPath *)indexPath
{
  int row = [indexPath row];
  if(row < [servers count])
  {
    return [servers objectAtIndex: row];
  }
  return nil;
}

#pragma mark - NSNetServiceDelegate methods
- (void) netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
  NSLog(@"Address not resolved");
  for(NSString *key in errorDict)
  {
    NSObject *value = [errorDict valueForKey:key];
    NSLog(@"Error: %@ : %@", key, value);
  }

  [[self delegate] didNotRefresh: self];
}

-(void) netServiceDidResolveAddress:(NSNetService *)sender
{
  Server *server = [[[Server alloc] initWithHostName:[sender hostName] andPort:[sender port]] autorelease];
  [servers addObject: server];
  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
  
  [center postNotificationName:SERVERS_REFRESHED object:self];
  
  [[self delegate] didRefresh: self];
}

@end
