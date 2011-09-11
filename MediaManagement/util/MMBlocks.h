//
//  ECBlocks.h
//  ECUtil
//
//  Created by Kra on 7/14/11.
//  Copyright 2011 Kra. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DispatchMainThread(X) if(X) dispatch_async(dispatch_get_main_queue(), ^{ X(); })
