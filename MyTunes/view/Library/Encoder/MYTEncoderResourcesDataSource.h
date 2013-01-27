//
//  MYTEncoderResourcesDataSource.h
//  MyTunes
//
//  Created by Olivier Larivain on 1/26/13.
//
//

#import <Foundation/Foundation.h>

@interface MYTEncoderResourcesDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *resourceList;

- (void) reload;

@end
