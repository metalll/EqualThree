//
//  NSDGameEngine.h
//  EqualThree
//
//  Created by NSD on 20.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSDSwap.h"
#import "NSDGameSharedInstance.h"

extern NSString * const NSDGameItemsDidMoveNotification;
extern NSString * const NSDGameItemsDidDeleteNotification;
extern NSString * const NSDDidGoToAwaitState;
extern NSString * const NSDDidUpdateUserScore;
extern NSString * const NSDDidUpdateMovesCount;
extern NSString * const NSDDidUpdadeSharedUserScore;
extern NSString * const kNSDGameItemsTypeCount;
extern NSString * const kNSDGameItems;
extern NSString * const kNSDGameItemTransitions;
extern NSString * const NSDDidFindPermissibleStroke;
extern NSString * const NSDDidDetectGameOver;
extern NSString * const kNSDUserScore;
extern NSString * const kNSDMovesCount;

extern NSUInteger const NSDGameItemScoreCost;

extern float const NSDRevertAnimationDuration;

@interface NSDGameEngine : NSObject

@property (strong) NSMutableArray *gameField;

- (instancetype)initWithHorizontalItemsCount:(NSUInteger)horizontalItemsCount
                          verticalItemsCount:(NSUInteger)verticalItemsCount
                              itemTypesCount:(NSUInteger)itemTypesCount;

- (instancetype)initWithSharedInstance:(NSDGameSharedInstance *)sharedInstance;


- (void)swapItemsWithSwap:(NSDSwap *)swap;

@end
