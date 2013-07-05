//
//  ServerIcon.h
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 kra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYTServer;

@interface MYTServerView : UICollectionViewCell
{
}

- (void) updateWithServer: (MYTServer *) server;

@end
