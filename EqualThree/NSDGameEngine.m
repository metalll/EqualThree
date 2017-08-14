//
//  NSDGameEngine.m
//  EqualThree
//
//  Created by NSD on 20.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGameEngine.h"
#import "NSDGameItemTransition.h"
#import "NSDIJStruct.h"
#import "NSDGameEngine+PatternSearch.h"
#import "NSDGameEngine+Notifications.h"
#import "NSDGameEngine+CheckPermissibleStroke.h"

NSString * const NSDGameItemsDidMoveNotification = @"NSDGameItemDidMoveNotification";
NSString * const NSDGameItemsDidDeleteNotification = @"NSDGameItemDidDeleteNotification";
NSString * const NSDDidGoToAwaitState = @"NSDEndOfTransitions";
NSString * const NSDDidUpdateUserScore = @"NSDDidUpdateUserScore";
NSString * const NSDDidUpdateMovesCount = @"NSDDidUpdateMoviesCount";
NSString * const NSDDidUpdadeSharedUserScore = @"NSDDidUpdadeSharedUserScore";
NSString * const NSDDidFindPermissibleStroke = @"NSDDidFindPermissibleStroke";
NSString * const NSDDidDetectGameOver = @"NSDDidDetectGameOver";
NSString * const kNSDGameItemsTypeCount = @"kNSDGameItemsTypeCount";
NSString * const kNSDUserScore = @"kNSDUserScore";
NSString * const kNSDMovesCount = @"kNSDUserMoviesCount";
NSString * const kNSDGameItems = @"kNSDGameItems";
NSString * const kNSDGameItemTransitions = @"kNSDGameItemTransitions";
NSUInteger const NSDGameItemScoreCost = 10;

float const NSDRevertAnimationDuration = 0.15f;

@interface NSDGameEngine ()

@property NSDSwap *lastUserSwap;
@property BOOL canRevertUserAction;

- (void)configureGameField;
- (void)restoreGameField;

- (NSUInteger)generateNewItemType;
- (void)fillGaps;
- (void)deleteItems:(NSArray *)matchingSequences;
- (void)checkMatchingItems;

- (void)applyUserAction;
- (void)revertUserAction;

@end

@implementation NSDGameEngine

#pragma mark - Constructors


- (instancetype)initWithSharedInstance:(NSDGameSharedInstance *)sharedInstance{
    
    self=[super init];
    
    if(self){
        
        _gameField = sharedInstance.field;
        _horizontalItemsCount =sharedInstance.field.count;
        _verticalItemsCount = ((NSArray *)sharedInstance.field.firstObject).count;
        _itemTypesCount = sharedInstance.sharedItemTypesCount;
        _userScore = sharedInstance.score;
        _movesCount = sharedInstance.moves;
        [self restoreGameField];
    }
    
    return self;
}

- (instancetype)initWithHorizontalItemsCount:(NSUInteger)horizontalItemsCount
                          verticalItemsCount:(NSUInteger)verticalItemsCount
                              itemTypesCount:(NSUInteger)itemTypesCount {
    
    self = [super init];
    
    if (self) {
        
        _horizontalItemsCount = horizontalItemsCount;
        _verticalItemsCount = verticalItemsCount;
        _itemTypesCount = itemTypesCount;
        _userScore = 0;
        _movesCount = 0;
        [self configureGameField];
        [self fillGaps];
    }
    return self;
}

#pragma mark - Public Methods

- (void)swapItemsWithSwap:(NSDSwap *)swap{
    
#ifdef DEBUG
    
    NSLog(@"swap items %@",swap);
    
#endif
    
    id tmp = self.gameField[swap.from.i][swap.from.j];
    self.gameField[swap.from.i][swap.from.j] = self.gameField[swap.to.i][swap.to.j];
    self.gameField[swap.to.i][swap.to.j] = tmp;
    
    
    NSMutableArray *newItemTransitions = [[NSMutableArray alloc] initWithCapacity:2];
    
    newItemTransitions[0] = [[NSDGameItemTransition alloc] initWithFrom:swap.from to:swap.to type:[self.gameField[swap.from.i][swap.from.j] unsignedIntegerValue]];
    
    newItemTransitions[1] = [[NSDGameItemTransition alloc] initWithFrom:swap.to to:swap.from type:[self.gameField[swap.to.i][swap.to.j] unsignedIntegerValue]];
    
    
    self.lastUserSwap = swap;
    
    [self notifyAboutItemsMovement:newItemTransitions];
    
    [self applyUserAction];
    
}

#pragma mark - Private

- (void)configureGameField{
    
    _gameField = [NSMutableArray arrayWithCapacity:self.horizontalItemsCount];
    
    for (NSUInteger i = 0; i < self.horizontalItemsCount; i++){
        
        NSMutableArray *column = [NSMutableArray arrayWithCapacity:self.verticalItemsCount];
        
        for (NSUInteger j = 0; j < self.verticalItemsCount; j++){
            
            [column addObject:[NSNull null]];
        }
        
        [self.gameField addObject:column];
    }
    
    [self notifyAboutDidUpdateMoviesCount];
    [self notifyAboutDidUpdateSharedUserScore];
}


-(void) restoreGameField{
    
    NSMutableArray *storedItemTransitions = [[NSMutableArray alloc] initWithCapacity:self.verticalItemsCount*self.horizontalItemsCount];
    
    for(NSUInteger i=0;i<self.verticalItemsCount;i++){
        for(NSUInteger j=0;j<self.horizontalItemsCount;j++){
            
            NSDGameItemTransition * itemTransition =[[NSDGameItemTransition alloc] initWithFrom:[NSDIJStruct new]
                                                                                             to:[NSDIJStruct new]
                                                                                           type:[self.gameField[i][j] unsignedIntegerValue]];
            
            itemTransition.from.i = i;
            itemTransition.to.i = i;
            itemTransition.to.j = j;
            itemTransition.from.j = j - self.verticalItemsCount;
            
            [storedItemTransitions addObject:itemTransition];
            
        }
    }
    
    [self notifyAboutItemsMovement:storedItemTransitions];
    [self notifyAboutDidUpdateMoviesCount];
    [self notifyAboutDidUpdateSharedUserScore];
    
    [self checkMatchingItems];
}


- (NSUInteger)generateNewItemType{
    NSUInteger result = arc4random_uniform(INT_MAX) % self.itemTypesCount;
    result++;
    return result;
}

- (void)applyUserAction{
    
    self.canRevertUserAction = YES;
    [self checkMatchingItems];
}

- (void)checkMatchingItems{
    
    NSMutableSet *result = [[NSMutableSet alloc] init];
    
    NSMutableArray *horizontalCheckPattern = [[NSMutableArray alloc] initWithArray:@[X, X, X] copyItems:NO];
    
    NSMutableArray *verticalCheckPattern = [[NSMutableArray alloc] initWithObjects:[[NSMutableArray alloc] initWithArray:@[X, X, X] copyItems:NO], nil];
    
    
    NSMutableArray *squareCheckPattern = [[NSMutableArray alloc] initWithObjects:[[NSMutableArray alloc] initWithArray:@[X,X] copyItems:NO],
                                          [[NSMutableArray alloc] initWithArray:@[X,X] copyItems:NO],
                                          nil];
    
    NSMutableArray *patterns = [[NSMutableArray alloc] initWithArray:@[verticalCheckPattern, squareCheckPattern, horizontalCheckPattern] copyItems:NO];
    
    for(NSUInteger currentType = 1; currentType <= self.itemTypesCount; currentType++){
        
        NSArray *configuredPatterns = [self configurePatternsWithArray:patterns
                                                               andType:currentType];
        
        for(NSUInteger i = 0; i < configuredPatterns.count; i++){
            
            NSArray *resultMatched =  [self checkMatchingPatternWithConfiguredPattern: configuredPatterns[i]];
            
            if(resultMatched != nil){
                
                [result addObjectsFromArray:resultMatched];
            }
        }
    }
    
    if(result.count > 0){
        
        if(self.canRevertUserAction){
            
            _movesCount++;
            
            self.canRevertUserAction = NO;
            
            [self notifyAboutDidUpdateMoviesCount];
            
        }
        
        [self deleteItems:result.allObjects];
        [self fillGaps];
        
#ifdef DEBUG
        NSLog(@"items to delete %@", result );
#endif
        
    } else {
        
#ifdef DEBUG
        
        NSLog(@"no has matches");
        
        for(NSUInteger i = 0; i < self.verticalItemsCount; i++){
            
            NSString *str = @"|";
            
            for(NSUInteger j = 0; j < self.horizontalItemsCount; j++){
                
                str = [str stringByAppendingString: [NSString stringWithFormat:@"%@|",_gameField[j][i]] ] ;
                
            }
            
            NSLog(@"game field %@",str);
        }
        
#endif
        
        if(self.canRevertUserAction){
            
            [self revertUserAction];
            
        } else {
            
            [self notifyAboutDidGoToAwaitState];
            
            [self checkPermissibleStroke];
        }
    }
}


- (void)fillGaps{
    
    NSMutableArray *newItemTransitions = [NSMutableArray new];
    
    for (NSUInteger i = 0; i < self.horizontalItemsCount; i++) {
        for (NSInteger j = self.verticalItemsCount - 1; j >= 0; j--) {
            if (self.gameField[i][j] == [NSNull null]) {
                
                NSDGameItemTransition *itemTransition = [[NSDGameItemTransition alloc] initWithFrom: [NSDIJStruct new] to:[NSDIJStruct new] type:0];
                
                itemTransition.to = [[NSDIJStruct alloc] init];
                itemTransition.from.i = i;
                itemTransition.to.i = i;
                itemTransition.to.j = j;
                itemTransition.from.j = j - self.verticalItemsCount;
                
                
                NSUInteger newItemType = [self generateNewItemType];
                self.gameField[i][j] = @(newItemType);
                itemTransition.type = newItemType;
                
                for (NSInteger k = j - 1; k >= 0; k--) {
                    if (self.gameField[i][k] != [NSNull null]) {
                        self.gameField[i][j] = self.gameField[i][k];
                        self.gameField[i][k] = [NSNull null];
                        itemTransition.from.j = k;
                        itemTransition.type = [self.gameField[i][j] integerValue];
                        break;
                    }
                }
                
                [newItemTransitions addObject:itemTransition];
            }
        }
    }
    
    [self notifyAboutItemsMovement:newItemTransitions];
    
    [self checkMatchingItems];
}

- (void)deleteItems:(NSArray *)matchingSequences{
    
    for(NSDIJStruct *tempStruct in matchingSequences){
        if(self.gameField[tempStruct.i][tempStruct.j] != [NSNull null]){
            self.gameField[tempStruct.i][tempStruct.j] = [NSNull null];
        }
    }
    
    [self notifyAboutItemsDeletion:matchingSequences];
    
    _userScore += matchingSequences.count * NSDGameItemScoreCost;
    
    [self notifyAboutDidUpdateUserScore];
}

- (void)revertUserAction{
    
    NSMutableArray *newItemTransitions = [[NSMutableArray alloc] initWithCapacity:2];
    
    newItemTransitions[0] = [[NSDGameItemTransition alloc] initWithFrom:self.lastUserSwap.to to:self.lastUserSwap.from type:[self.gameField[self.lastUserSwap.to.i][self.lastUserSwap.to.j] unsignedIntegerValue] animationDuration:NSDRevertAnimationDuration];
    
    newItemTransitions[1] = [[NSDGameItemTransition alloc] initWithFrom:self.lastUserSwap.from to:self.lastUserSwap.to type:[self.gameField[self.lastUserSwap.from.i][self.lastUserSwap.from.j] unsignedIntegerValue] animationDuration:NSDRevertAnimationDuration];
    
    [self notifyAboutItemsMovement:newItemTransitions];
    
    id tmp = self.gameField[self.lastUserSwap.from.i][self.lastUserSwap.from.j];
    self.gameField[self.lastUserSwap.from.i][self.lastUserSwap.from.j] = self.gameField[self.lastUserSwap.to.i][self.lastUserSwap.to.j];
    self.gameField[self.lastUserSwap.to.i][self.lastUserSwap.to.j] = tmp;
    
    self.canRevertUserAction = NO;
    
    [self notifyAboutDidGoToAwaitState];
}

@end
