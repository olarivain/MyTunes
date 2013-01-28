//
//  MYTEncoderResourcesDataSource.h
//  MyTunes
//
//  Created by Olivier Larivain on 1/26/13.
//
//

#import <Foundation/Foundation.h>

@class MMTitleList;

@protocol MYTEncoderDataSourceDelegate <NSObject>

- (void) didSelectTitleList: (MMTitleList *) titleList;
- (void) didDeselectTitleList: (MMTitleList *) titleList;

@end

@interface MYTEncoderDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet id<MYTEncoderDataSourceDelegate> delegate;
@property (nonatomic, readonly) NSArray *selectedResources;

- (void) reload: (BOOL) filtered;
- (void) deselectCurrentCell;

@end
