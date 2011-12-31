//
//  MMPlaylistContentCellSize.h
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 Edmunds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMPlaylistContentCellSize : NSObject
{
  CGSize nameSize;
  CGFloat totalHeight;
}

@property (nonatomic, readwrite, assign) CGSize nameSize;
@property (nonatomic, readwrite, assign) CGFloat totalHeight;

+ (MMPlaylistContentCellSize *) playlistContentCellSize;

@end
