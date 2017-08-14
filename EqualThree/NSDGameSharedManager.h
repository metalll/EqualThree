//
//  GameSharedManager.h
//  EqualThree
//
//  Created by NSD on 03.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//


#import "NSDGameSharedInstance.h"

extern NSString * const kNSDFileName;

@interface NSDGameSharedManager : NSObject


+ (instancetype) sharedInstance;

- (NSDGameSharedInstance *)lastSavedGame;
- (void)hasSavedGameWithCompletion:(void (^)(BOOL hasSavedGame))completion;

- (void)deleteGame;

@end
