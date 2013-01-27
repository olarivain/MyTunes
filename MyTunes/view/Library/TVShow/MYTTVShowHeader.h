//
//  MYTTVShowHeader.h
//  MyTunes
//
//  Created by Olivier Larivain on 1/26/13.
//
//

#import <UIKit/UIKit.h>

@class MMTVShowSeason;

@protocol MYTTVShowHeaderDelegate <NSObject>

- (void) didMarkAsViewed: (MMTVShowSeason *) season;

@end

@interface MYTTVShowHeader : UIView

@property (strong, nonatomic, readonly) MMTVShowSeason *season;
@property (weak, nonatomic) id<MYTTVShowHeaderDelegate> delegate;

- (void) updateWithShow: (MMTVShowSeason *) season;

@end
