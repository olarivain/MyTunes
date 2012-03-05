//
//  MMPlaylistContentCell.m
//  MediaManagement
//
//  Created by Larivain, Olivier on 12/31/11.
//  Copyright (c) 2011 kra. All rights reserved.
//

#import <MediaManagement/MMContent.h>

#import "MMPlaylistContentCell.h"

#import "NSNumber+NSNumber_NonZero.h"
#import "MMPlaylistContentCellSize.h"

@interface MMPlaylistContentCell()
- (NSString *) trackNumberForContent: (MMContent *) content;

- (void) updateResizeMask;
- (CGSize) nameSizeForContent: (MMContent *) content;
@end

@implementation MMPlaylistContentCell

#pragma mark - Updating Content
- (void) updateWithContent: (MMContent *) content withCellSize: (MMPlaylistContentCellSize *) size
{
  // update name frame and content
  CGRect nameFrame = name.frame;
  nameFrame.size = size.nameSize;
  name.frame = nameFrame;
  name.text = content.name;
  
  // set track number
  NSString *trackNumber = [self trackNumberForContent: content];
  number.text = trackNumber;
}

#pragma mark Convenience getter for track number
- (NSString *) trackNumberForContent: (MMContent *) content
{
  if([content isTvShow])
  {
    return content.episodeNumber == nil ? @"" : [content.episodeNumber nonZeroStringValue];
  }
  
  if ([content isMusic])
  {
    return  content.trackNumber == nil ? @"" : [content.trackNumber nonZeroStringValue];
  }

  return @"";
}

#pragma mark - Sizing 
- (void) updateSizeWithWidth: (CGFloat) width
{
  [self updateResizeMask];
  
  CGRect theFrame = self.frame;
  theFrame .size.width = width;
  self.frame = theFrame;
}

- (MMPlaylistContentCellSize *) sizeForContent: (MMContent *) content
{ 
  MMPlaylistContentCellSize *size = [MMPlaylistContentCellSize playlistContentCellSize];
  size.nameSize = [self nameSizeForContent: content];
  size.totalHeight = size.nameSize.height + 2 * name.frame.origin.y;
  return size;
}

- (CGSize) nameSizeForContent: (MMContent *) content
{
  CGSize nameConstrainedSize = CGSizeMake(name.frame.size.width, 9999);
  return [content.name sizeWithFont: name.font constrainedToSize: nameConstrainedSize lineBreakMode: name.lineBreakMode];
}

- (void) updateResizeMask
{
  name.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  
}

@end
