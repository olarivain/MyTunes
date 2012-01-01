//
//  MMTitleDetailCellSize.h
//  MediaManagement
//
//  Created by Larivain, Olivier on 1/1/12.
//  Copyright (c) 2012 Edmunds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMTitleDetailCellSize : NSObject
{
  CGFloat audioTracksHeight;
  CGFloat subtitleTracksHeight;
  CGFloat totalHeight;
}

@property (nonatomic, readwrite, assign) CGFloat audioTracksHeight;
@property (nonatomic, readwrite, assign) CGFloat subtitleTracksHeight;
@property (nonatomic, readwrite, assign) CGFloat totalHeight;

+ (MMTitleDetailCellSize *) titleDetailCellSize;

@end
