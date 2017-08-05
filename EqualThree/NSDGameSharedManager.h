//
//  GameSharedManager.h
//  EqualThree
//
//  Created by NSD on 03.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDGameSharedInstance.h"

extern NSString * const kNSDFileName;

@interface NSDGameSharedManager : NSObject


+(instancetype) sharedInstance;

-(NSDGameSharedInstance *)lastSavedGame;
-(void)hasSavedGameWithCompletion:(void(^)(BOOL isHasSavedGame))completion;

-(void)deleteGame;


@end
