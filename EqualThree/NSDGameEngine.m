//
//  NSDGameEngine.m
//  EqualThree
//
//  Created by NSD on 20.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGameEngine.h"
#import "NSDGameItemTransition.h"
#import "NSDMatchingSequence.h"


NSString * const NSDGameItemsDidMoveNotification = @"NSDGameItemDidMoveNotification";
NSString * const NSDGameItemsDidDeleteNotification = @"NSDGameItemDidDeleteNotification";
NSString * const kNSDGameItems = @"kNSDGameItems";
NSString * const kNSDGameItemTransitions = @"kNSDGameItemTransitions";








@interface NSDGameEngine ()

@property NSUInteger horizontalItemsCount;
@property NSUInteger verticalItemsCount;
@property NSUInteger itemTypesCount;

@property BOOL canRevertUserAction;



- (void)notifyAboutItemsMovement:(NSArray*)items;
- (void)notifyAboutItemsDeletion:(NSArray*)items;

- (void)configureGameField;
- (NSUInteger)generateNewItemType;
- (void)applyUserAction;
- (void)checkMatchingItems;
- (void)fillGaps;
- (void)deleteItems:(NSArray*)matchingSequences;
- (void)revertUserAction;

@end

@implementation NSDGameEngine

#pragma mark - Constructors

- (instancetype)initWithHorizontalItemsCount:(NSUInteger)horizontalItemsCount
                          verticalItemsCount:(NSUInteger)verticalItemsCount
                              itemTypesCount:(NSUInteger)itemTypesCount {
    self = [super init];
    if (self) {
        self.horizontalItemsCount = horizontalItemsCount;
        self.verticalItemsCount = verticalItemsCount;
        self.itemTypesCount = itemTypesCount;
        [self configureGameField];
        [self fillGaps];
    }
    return self;
}

#pragma mark - Public Methods

- (void)swapItemAtX0:(NSUInteger)x0
                  y0:(NSUInteger)y0
        withItemAtX1:(NSUInteger)x1
                  y1:(NSUInteger)y1 {
    
    
    NSUInteger temp = [_gameField[x1][y1] unsignedIntegerValue ];
    

    
    _gameField[x1][y1] =  _gameField[x0][y0];
    _gameField[x0][y0] = @(temp);
    
    
    
    
    NSMutableArray * tranzactions = [NSMutableArray arrayWithCapacity:2];
    [tranzactions addObject:[ [NSDGameItemTransition alloc]initWithX0:x0 andY0:y0 andX1:x1 andY1:y1 andType:[ _gameField[x0][y0] unsignedIntegerValue]]];
    [tranzactions addObject:[[NSDGameItemTransition alloc]initWithX0:x1 andY0:y1 andX1:x0 andY1:y0 andType:[ _gameField[x1][y1] unsignedIntegerValue]]];
    
    [self notifyAboutItemsMovement:tranzactions];
    
    
    
  //  [self applyUserAction];
}

#pragma mark - Private

- (void)configureGameField {
    self->_gameField = [NSMutableArray arrayWithCapacity:self.horizontalItemsCount];
    for (NSUInteger i = 0; i < self.horizontalItemsCount; i++) {
        NSMutableArray *column = [NSMutableArray arrayWithCapacity:self.verticalItemsCount];
        for (NSUInteger j = 0; j < self.verticalItemsCount; j++) {
            [column addObject:[NSNull null]];
        }
        [self.gameField addObject:column];
    }
}

- (NSUInteger)generateNewItemType {
    NSUInteger result = arc4random_uniform(INT_MAX) % self.itemTypesCount;
    return result;
}

- (void)applyUserAction {
    //todo: do stuff
    //todo: notifyAboutItemsMovement
    self.canRevertUserAction = YES;
    [self checkMatchingItems];
}

- (void)checkMatchingItems {
    NSMutableArray *matchingItems = [NSMutableArray arrayWithCapacity:10];
    
    //C
    size_t array_size = self.itemTypesCount * sizeof(NSUInteger);
    NSUInteger *counters = (NSUInteger*)malloc(array_size);
    
    for (NSUInteger i = 0; i < self.horizontalItemsCount; i++) {
        memset(counters, 0, array_size);
        for (NSUInteger j = 0; j < self.verticalItemsCount; j++) {
            NSUInteger currentValue = [self.gameField[i][j] unsignedIntegerValue];
            NSUInteger nextValue = INT_MAX;
            if (j < self.verticalItemsCount-1) {
                nextValue = [self.gameField[i][j+1] unsignedIntegerValue];
            }
            counters[currentValue]++;
            if (currentValue != nextValue) {
                NSUInteger sequence_length = counters[currentValue];
                if (sequence_length >=3 ) {
                    NSDMatchingSequence *matchingSequence = [NSDMatchingSequence new];
                    matchingSequence.i0 = i;
                    matchingSequence.j0 = j - sequence_length + 1;
                    matchingSequence.i1 = i;
                    matchingSequence.j1 = j;
                    [matchingItems addObject:matchingSequence];
                }
                counters[currentValue] = 0;
            }
        }
    }
    
    for (NSUInteger j = 0; j < self.verticalItemsCount; j++) {
        memset(counters, 0, array_size);
        for (NSUInteger i = 0; i < self.horizontalItemsCount; i++) {
            NSUInteger currentValue = [self.gameField[i][j] unsignedIntegerValue];
            NSUInteger nextValue = INT_MAX;
            if (i < self.horizontalItemsCount-1) {
                nextValue = [self.gameField[i+1][j] unsignedIntegerValue];
            }
            counters[currentValue]++;
            if (currentValue != nextValue) {
                NSUInteger sequence_length = counters[currentValue];
                if (sequence_length >=3 ) {
                    NSDMatchingSequence *matchingSequence = [NSDMatchingSequence new];
                    matchingSequence.i0 = i - sequence_length + 1;
                    matchingSequence.j0 = j;
                    matchingSequence.i1 = i;
                    matchingSequence.j1 = j;
                    [matchingItems addObject:matchingSequence];
                }
                counters[currentValue] = 0;
            }
        }
    }
    
    free(counters);
    //end of C
    
    if (matchingItems.count > 0) {
        self.canRevertUserAction = NO;
        [self deleteItems:matchingItems];
    } else {
        if (self.canRevertUserAction == YES) {
            [self revertUserAction];
        }
        else {
            //go to "awaiting input" state
        }
    }
}

- (void)fillGaps {
    NSMutableArray *newItemTransitions = [NSMutableArray new];
    for (NSUInteger i = 0; i < self.horizontalItemsCount; i++) {
        for (NSInteger j = self.verticalItemsCount - 1; j >= 0; j--) {
            if (self.gameField[i][j] == [NSNull null]) {
                
                NSDGameItemTransition *itemTransition = [NSDGameItemTransition new];
                itemTransition.x0 = i;
                itemTransition.x1 = i;
                itemTransition.y1 = j;
                
                if ((j != 0) && (self.gameField[i][j-1] != [NSNull null])) {
                    self.gameField[i][j] = self.gameField[i][j-1];
                    self.gameField[i][j-1] = [NSNull null];
                    itemTransition.y0 = j - 1;
                    itemTransition.type = [self.gameField[i][j] integerValue];
                }
                else {
                    NSUInteger newItemType = [self generateNewItemType];
                    self.gameField[i][j] = @(newItemType);
                    itemTransition.y0 =  (self.verticalItemsCount * - 1 ) + j ;
                    itemTransition.type = newItemType;
                }
                
                [newItemTransitions addObject:itemTransition];
            }
        }
    }
    [self notifyAboutItemsMovement:newItemTransitions];
 //   [self checkMatchingItems];
}

- (void)deleteItems:(NSArray*)matchingSequences {
    for (NSDMatchingSequence *matchingSequence in matchingSequences) {
        for (NSUInteger i = matchingSequence.i0; i <= matchingSequence.i1; i++) {
            for (NSUInteger j = matchingSequence.j0; j <= matchingSequence.j1; j++) {
                self.gameField[i][j] = [NSNull null];
            }
        }
    }

    [self notifyAboutItemsDeletion:matchingSequences];
    [self fillGaps];
}

- (void)revertUserAction {
    //todo: do stuff
    //todo: notifyAboutItemsMovement
}



#pragma mark - Notifications

- (void)notifyAboutItemsMovement:(NSArray*)itemTransitions {
    NSNotification *notification = [NSNotification notificationWithName:NSDGameItemsDidMoveNotification
                                                                 object:nil
                                                               userInfo:@{kNSDGameItemTransitions : itemTransitions}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)notifyAboutItemsDeletion:(NSArray*)items {
    NSNotification *notification = [NSNotification notificationWithName:NSDGameItemsDidDeleteNotification
                                                                 object:nil
                                                               userInfo:@{kNSDGameItems : items}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
