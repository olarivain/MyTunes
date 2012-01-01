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
  CGFloat titleTracksHeight;
  CGFloat totalHeight;
}

@property (nonatomic, readwrite, assign) CGFloat titleTracksHeight;
@property (nonatomic, readwrite, assign) CGFloat totalHeight;

+ (MMTitleDetailCellSize *) titleDetailCellSize;

@end
