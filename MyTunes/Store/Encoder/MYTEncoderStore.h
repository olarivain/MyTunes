//
//  MYTEncoderStore.h
//  MyTunes
//
//  Created by Olivier Larivain on 1/26/13.
//
//

#import <Foundation/Foundation.h>

@class MMEncoderResources;

@interface MYTEncoderStore : NSObject

+ (MYTEncoderStore *) sharedInstance;

@property (strong, nonatomic, readonly) MMEncoderResources *resources;

- (void) loadEncoderResources: (KCErrorBlock) callback;
@end
