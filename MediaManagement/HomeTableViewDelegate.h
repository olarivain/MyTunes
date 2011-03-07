//
//  HomeTableController.h
//  MediaManagement
//
//  Created by Kra on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServersDelegate.h"

@class Servers;

@interface HomeTableViewDelegate : NSObject<UITableViewDelegate, UITableViewDataSource, ServersDelegate>
{
  Servers *servers;
  IBOutlet UITableView *table;
}

- (void) refresh;

@end
