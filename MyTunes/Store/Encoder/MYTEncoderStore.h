//
//  MYTEncoderStore.h
//  MyTunes
//
//  Created by Olivier Larivain on 1/26/13.
//
//

#import <Foundation/Foundation.h>

@class MMEncoderResources;
@class MMTitleList;

@interface MYTEncoderStore : NSObject

+ (MYTEncoderStore *) sharedInstance;

@property (strong, nonatomic, readonly) MMEncoderResources *resources;

- (void) loadEncoderResources: (KCErrorBlock) callback;
- (void) loadResource: (MMTitleList *) titleList
             callback: (KCErrorBlock) callback;
- (void) encodeResource: (MMTitleList *) titleList
               callback: (KCErrorBlock) callback;
@end
