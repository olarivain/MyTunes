//
//  MYTEncoderStore.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/26/13.
//
//
#import <KraCommons/KCHTTPClient.h>

#import "MYTEncoderStore.h"

#import "MYTServerStore.h"
#import "MYTServer.h"
#import "MMEncoderResources.h"

#import "MMTitleAssembler+Client.h"

static MYTEncoderStore *sharedInstance;

@interface MYTEncoderStore ()
@property (strong, nonatomic, readwrite) MMEncoderResources *resources;
@end

@implementation MYTEncoderStore

+ (MYTEncoderStore *) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MYTEncoderStore alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Loading encoder resources
- (void) loadEncoderResources: (KCErrorBlock) callback {
    MYTServer *server = [MYTServerStore sharedInstance].currentServer;
    [server.httpClient getPath: @"/encoder"
                    parameters: nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           [self didLoadEncoderResources: responseObject
                                                callback: callback];
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           self.resources = nil;
                           DispatchMainThread(callback, error);
                       }];
}

- (void) didLoadEncoderResources: (NSArray *) dtos
                        callback: (KCErrorBlock) callback {
    MMEncoderResources *resources = [MMEncoderResources encoderResources];
    MMTitleAssembler *assembler = [MMTitleAssembler sharedInstance];
    NSArray *titleLists = [assembler createTitleLists: dtos];
    [resources addTitleLists: titleLists];
    self.resources = resources;
    
    
    DispatchMainThread(callback, nil);
}



@end
