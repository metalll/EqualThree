//
//  GameSharedManager.h
//  EqualThree
//
//  Created by NSD on 03.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDGameSharedInstance.h"

extern NSString * const kNSDfName;

@interface NSDGameSharedManager : NSObject


+(instancetype) sharedInstance;

-(NSDGameSharedInstance *)lastSavedGame;




@end
