//
//  NSDGameEngine.h
//  EqualThree
//
//  Created by NSD on 20.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const NSDGameItemsDidMoveNotification;
extern NSString * const NSDGameItemsDidDeleteNotification;
extern NSString * const kNSDGameItems;
extern NSString * const kNSDGameItemTransitions;

@interface NSDGameEngine : NSObject

@property (nonatomic, strong,readonly) NSMutableArray * gameField;

- (instancetype)initWithHorizontalItemsCount:(NSUInteger)horizontalItemsCount
                          verticalItemsCount:(NSUInteger)verticalItemsCount
                              itemTypesCount:(NSUInteger)itemTypesCount;

- (void)swapItemAtX0:(NSUInteger)x0
                  y0:(NSUInteger)y0
        withItemAtX1:(NSUInteger)x1
                  y1:(NSUInteger)y1;

@end
