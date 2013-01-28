//
//  MYTEncoderStore.m
//  MyTunes
//
//  Created by Olivier Larivain on 1/26/13.
//
//
#import <KraCommons/KCHTTPClient.h>
#import <KraCommons/NSString+URLEncoding.h>

#import <MediaManagement/MMTitleList.h>

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

#pragma mark - Loading all resources
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

#pragma mark - loading a resource
- (void) loadResource: (MMTitleList *) titleList
             callback: (KCErrorBlock) callback {
    NSString *encodedTitleName = [titleList.titleListId stringByURLEncoding];
    NSString *path = [NSString stringWithFormat: @"/encoder/%@", encodedTitleName];
    MYTServer *server = [MYTServerStore sharedInstance].currentServer;
    [server.httpClient getPath: path
                    parameters: nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           [self didLoadResource: responseObject
                                       titleList: titleList
                                        callback: callback];
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           DispatchMainThread(callback, error);
                       }];
}

- (void) didLoadResource: (NSDictionary *) dto
               titleList: (MMTitleList *) titleList
                callback: (KCErrorBlock) callback {
    MMTitleAssembler *assembler = [MMTitleAssembler sharedInstance];
    [assembler updateTitleList: titleList withDto: dto];
    
    DispatchMainThread(callback, nil);
}

#pragma mark - encoding a resource
- (void) encodeResource: (MMTitleList *) titleList
               callback: (KCErrorBlock) callback {
    MMTitleAssembler *assembler = [MMTitleAssembler sharedInstance];
    NSDictionary *params = [assembler writeTitleList: titleList];
    
    NSString *encodedTitleName = [titleList.titleListId stringByURLEncoding];
    NSString *path = [NSString stringWithFormat: @"/encoder/%@", encodedTitleName];
    MYTServer *server = [MYTServerStore sharedInstance].currentServer;
    [server.httpClient postPath: path
                     parameters: params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            DispatchMainThread(callback, nil);
                        }
                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            DispatchMainThread(callback, error);
                        }];
}

- (void) deleteResources:(NSArray *)titleLists
                callback:(KCErrorBlock)callback {
    MMTitleAssembler *assembler = [MMTitleAssembler sharedInstance];
    NSDictionary *params = [assembler writeTitleListIDs: titleLists];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
    MYTServer *server = [MYTServerStore sharedInstance].currentServer;
    [server.httpClient deletePath: @"/encoder"
                       parameters: params
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              DispatchMainThread(callback, nil);
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              DispatchMainThread(callback, error);
                          }];
#pragma clang diagnostic pop
}


@end
