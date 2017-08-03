//
//  GameSharedManager.h
//  EqualThree
//
//  Created by NSD on 03.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDGameSharedInstance.m"
@interface NSDGameSharedManager : NSObject


+(instancetype) sharedInstance;

-(void)loadGameWithCompletion;







@end
