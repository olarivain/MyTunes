//
//  MMTitleAssembler+Client.m
//  MediaManagement
//
//  Created by Olivier Larivain on 3/10/12.
//  Copyright (c) 2012 kra. All rights reserved.
//
#import <MediaManagement/MMTitle.h>
#import <MediaManagement/MMTitleList.h>
#import <MediaManagement/MMSubtitleTrack.h>
#import <MediaManagement/MMAudioTrack.h>

#import "MMTitleAssembler+Client.h"

@implementation MMTitleAssembler (Client)

#pragma mark - Creating a fresh title list (DTO -> domain)
- (NSArray *) createTitleLists: (NSArray *) dtos
{
  if(dtos == nil)
  {
    return nil;
  }
  
  NSMutableArray *titleLists = [NSMutableArray arrayWithCapacity: [dtos count]];
  for(NSDictionary *dto in dtos)
  {
    MMTitleList *titleList = [self createTitleList: dto];
    if(titleList == nil)
    {
      continue;
    }
    [titleLists addObject: titleList];
  }
  return titleLists;
}


- (MMTitleList *) createTitleList: (NSDictionary *) dto
{
  if(dto == nil)
  {
    return nil;
  }
  
  NSString *titleListId = [dto nullSafeForKey: @"id"];
  MMTitleList *titleList = [MMTitleList titleListWithId: titleListId];
  [self updateTitleList: titleList withDto: dto];
  
  return titleList;
}

#pragma mark - Update a title list with fresh new titles
- (void) updateTitleList: (MMTitleList *) titleList withDto: (NSDictionary *) dto
{
  NSArray *titleDtos = [dto nullSafeForKey: @"titles"];
  // no title exist yet, create fresh new instances
  if([titleList.titles count] == 0)
  {
    for(NSDictionary *titleDto in titleDtos)
    {
      MMTitle *title = [self createTitle: titleDto];
      [titleList addtitle: title];
    }
  }
  else 
  {
    // otherwise, just update every title with new server stuff
    for(NSDictionary *titleDto in titleDtos)
    {
      
      NSInteger titleIndex = [titleDto integerForKey: @"index"];
      MMTitle *title = [titleList titleWithIndex: titleIndex];
      [self updateTitle: title withDto: titleDto];
    }
  }
}

#pragma mark Create a fresh new title
- (MMTitle *) createTitle: (NSDictionary *) dto
{
  if(dto == nil)
  {
    return nil;
  }
  
  // build MMTitle
  NSInteger index = [dto integerForKey: @"index"];
  NSTimeInterval duration = [dto doubleForKey: @"duration"];
  MMTitle *title = [MMTitle titleWithIndex: index andDuration:duration];
  title.selected = [dto boolForKey: @"selected"];
  title.completed = [dto boolForKey: @"completed"];
  title.eta = [dto integerForKey: @"eta"];
  title.encoding = [dto integerForKey: @"encoding"];
  title.progress = [dto integerForKey: @"progress"];
  
  // create all audio tracks and add them to hte title object
  NSArray *audioTrackDtos = [dto nullSafeForKey: @"audioTracks"];
  for(NSDictionary *audioTrackDto in audioTrackDtos)
  {
    MMAudioTrack *audioTrack = [self createAudioTrack: audioTrackDto];
    [title addAudioTrack: audioTrack];
  }
  
  // create all subtitle track objects and add them to the title object
  NSArray *subtitleTrackDtos = [dto nullSafeForKey: @"subtitleTracks"];
  for(NSDictionary *subtitleTrackDto in subtitleTrackDtos)
  {
    MMSubtitleTrack *subtitleTrack = [self createSubtitleTrack: subtitleTrackDto];
    [title addSubtitleTrack: subtitleTrack];
  }
  
  return title;
}

- (MMAudioTrack *) createAudioTrack: (NSDictionary *) dto
{
  if(dto == nil)
  {
    return nil;
  }
  
  NSInteger index = [dto integerForKey: @"index"];
  MMAudioCodec codec = (MMAudioCodec) [dto integerForKey: @"codec"];
  NSInteger channelCount = [dto integerForKey: @"channelCount"];
  BOOL lfe = [dto boolForKey: @"lfe"];
  NSString *language = [dto nullSafeForKey: @"language"];
  MMAudioTrack *audioTrack = [MMAudioTrack audioTrackWithIndex: index 
                                                         codec: codec 
                                                  channelCount: channelCount 
                                                           lfe: lfe 
                                                   andLanguage: language];
  audioTrack.selected = [dto boolForKey: @"selected"];
  return audioTrack;
}

- (MMSubtitleTrack *) createSubtitleTrack: (NSDictionary *) dto
{
  if(dto == nil)
  {
    return nil;
  }
  
  NSInteger index = [dto integerForKey: @"index"];
  NSString *language = [dto nullSafeForKey: @"language"];
  MMSubtitleType type = (MMSubtitleType) [dto integerForKey: @"type"];
  MMSubtitleTrack *track = [MMSubtitleTrack subtitleTrackWithIndex: index 
                                                          language: language 
                                                           andType: type];
  track.selected = [dto boolForKey: @"selected"];
  return track;
}

#pragma mark - Update an MMTitleList with server content
- (void) updateTitle:(MMTitle *)title withDto:(NSDictionary *)dto
{
  // and update its status
  title.eta = [dto integerForKey: @"eta"];
  title.progress = [dto integerForKey: @"progress"];
  title.completed = [dto boolForKey: @"completed"];
  title.encoding =[dto boolForKey: @"encoding"];
  
  // update all audio tracks
  NSArray *audioTrackDtos = [dto nullSafeForKey: @"audioTracks"];
  for(NSDictionary *audioTrackDto in audioTrackDtos)
  {
    NSInteger audioIndex = [audioTrackDto integerForKey: @"index"];
    MMAudioTrack *audioTrack = [title audioTrackWithIndex: audioIndex];
    audioTrack.selected = [audioTrackDto boolForKey: @"selected"];  
  }
  
  // update all subtitle tracks
  NSArray *subtitleTrackDtos = [dto nullSafeForKey: @"subtitleTracks"];
  for(NSDictionary *subtitleTrackDto in subtitleTrackDtos)
  {
    NSInteger subtitleIndex = [subtitleTrackDto integerForKey: @"index"];
    MMSubtitleTrack *subtitleTrack = [title subtitleTrackWithIndex: subtitleIndex];
    subtitleTrack.selected = [subtitleTrackDto boolForKey: @"selected"];  
  } 
}

@end
