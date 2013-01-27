//
//  MYTTVShowHeader.h
//  MyTunes
//
//  Created by Olivier Larivain on 1/26/13.
//
//

#import <UIKit/UIKit.h>

@class MMTVShowSeason;

@interface MYTTVShowHeader : UIView

- (void) updateWithShow: (MMTVShowSeason *) season;

@end
