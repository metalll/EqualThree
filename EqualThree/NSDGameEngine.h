//
//  NSDGameEngine.h
//  EqualThree
//
//  Created by NSD on 20.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSDSwap.h"

extern NSString * const NSDGameItemsDidMoveNotification;
extern NSString * const NSDGameItemsDidDeleteNotification;
extern NSString * const NSDEndOfTransitions;
extern NSString * const NSDDidUpdateUserScore ;
extern NSString * const NSDDidUpdateMoviesCount ;



extern NSString * const kNSDGameItems;
extern NSString * const kNSDGameItemTransitions;


extern NSString * const kNSDUserScore;
extern NSString * const kNSDMoviesCount ;

extern NSUInteger const NSDGameItemScoreCost;

@interface NSDGameEngine : NSObject

@property (strong) NSMutableArray * gameField;

- (instancetype)initWithHorizontalItemsCount:(NSUInteger)horizontalItemsCount
                          verticalItemsCount:(NSUInteger)verticalItemsCount
                              itemTypesCount:(NSUInteger)itemTypesCount;

- (void)swapItemsWithSwap:(NSDSwap *) swap;

@end
