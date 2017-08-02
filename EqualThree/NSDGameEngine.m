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



NSString * const NSDGameItemsDidMoveNotification = @"NSDGameItemDidMoveNotification";
NSString * const NSDGameItemsDidDeleteNotification = @"NSDGameItemDidDeleteNotification";
NSString * const NSDEndOfTransitions = @"NSDEndOfTransitions";
NSString * const NSDDidUpdateUserScore = @"NSDDidUpdateUserScore";
NSString * const NSDDidUpdateMoviesCount = @"NSDDidUpdateMoviesCount";


NSString * const NSDDidFindPotentialMathed = @"NSDDidFindPotentialMathed";
NSString * const NSDDidDetectGameOver = @"NSDDidDetectGameOver";




NSString * const kNSDUserScore = @"kNSDUserScore";
NSString * const kNSDMoviesCount = @"kNSDUserMoviesCount";

NSString * const kNSDGameItems = @"kNSDGameItems";
NSString * const kNSDGameItemTransitions = @"kNSDGameItemTransitions";

NSUInteger const NSDGameItemScoreCost = 10;







@interface NSDGameEngine ()

@property NSUInteger horizontalItemsCount;
@property NSUInteger verticalItemsCount;
@property NSUInteger itemTypesCount;

@property NSLock * mutex;
@property dispatch_queue_t operationQueue;


@property NSUInteger userScore;
@property NSUInteger moviesCount;

@property BOOL canRevertUserAction;

- (void)notifyAboutItemsMovement:(NSArray*)items;
- (void)notifyAboutItemsDeletion:(NSArray*)items;
- (void)notifyAboutkEndOfTransitions;
-(void) notifyAboutDidUpdateMoviesCount;
- (void)notifyAboutDidUpdateUserScore;

- (void)configureGameField;
- (NSUInteger)generateNewItemType;
- (void)applyUserAction;
- (void)checkMatchingItems;
- (void)fillGaps;
- (void)deleteItems:(NSArray*)matchingSequences;
- (void)revertUserAction;


@property NSDSwap * lastUserSwap;

@end

@implementation NSDGameEngine

#pragma mark - Constructors

- (instancetype)initWithHorizontalItemsCount:(NSUInteger)horizontalItemsCount
                          verticalItemsCount:(NSUInteger)verticalItemsCount
                              itemTypesCount:(NSUInteger)itemTypesCount {
    self = [super init];
    if (self) {
        self.mutex = [[NSLock alloc] init];
        self.operationQueue = dispatch_queue_create("com.nsd.game.engine.queue", DISPATCH_QUEUE_SERIAL);
        self.horizontalItemsCount = horizontalItemsCount;
        self.verticalItemsCount = verticalItemsCount;
        self.itemTypesCount = itemTypesCount;
        self.userScore = 0;
        self.moviesCount = 0;
        [self configureGameField];
        [self fillGaps];
    }
    return self;
}

#pragma mark - Public Methods



- (void)swapItemsWithSwap:(NSDSwap *) swap{
    
#ifdef DEBUG
    
    NSLog(@"swap items %@",swap);
    
#endif
    
    
    id tmp = self.gameField[swap.from.i][swap.from.j];
    self.gameField[swap.from.i][swap.from.j] = self.gameField[swap.to.i][swap.to.j];
    self.gameField[swap.to.i][swap.to.j] = tmp;
    
    
    
    
    NSMutableArray * newItemTransitions = [[NSMutableArray alloc] initWithCapacity:2];
    
    newItemTransitions[0] = [[NSDGameItemTransition alloc] initWithFrom:swap.from to:swap.to type:[self.gameField[swap.from.i][swap.from.j] unsignedIntegerValue]];
    
    newItemTransitions[1] = [[NSDGameItemTransition alloc] initWithFrom:swap.to to:swap.from type:[self.gameField[swap.to.i][swap.to.j] unsignedIntegerValue]];
    
    
    self.lastUserSwap = swap;
    
    [self notifyAboutItemsMovement:newItemTransitions];
    
    [self applyUserAction];
    
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
    result++;
    return result;
}

- (void)applyUserAction {
    
    
    
    
    self.canRevertUserAction = YES;
    [self checkMatchingItems];
}

- (void)checkMatchingItems {
    
    
    
    
    NSMutableSet * result = [[NSMutableSet alloc] init];
    
    
    NSMutableArray * horizontalCheckPattern = [[NSMutableArray alloc] initWithArray:@[[NSNull null],[NSNull null], [NSNull null] ] copyItems:NO];
    
    NSMutableArray * verticalCheckPattern = [[NSMutableArray alloc] initWithObjects:[[NSMutableArray alloc] initWithArray:@[[NSNull null],[NSNull null],[NSNull null]] copyItems:NO], nil];
    
    
    NSMutableArray * squareCheckPattern = [[NSMutableArray alloc] initWithObjects:[[NSMutableArray alloc] initWithArray:@[[NSNull null],[NSNull null]] copyItems:NO],[[NSMutableArray alloc] initWithArray:@[[NSNull null],[NSNull null]] copyItems:NO], nil];
    
    NSMutableArray * patterns = [[NSMutableArray alloc] initWithArray:@[verticalCheckPattern,squareCheckPattern,horizontalCheckPattern] copyItems:NO];
    
    
    
    
    for(NSUInteger currentType=1;currentType<=self.itemTypesCount;currentType++){
        
        NSArray * configuredPatterns = [self configurePatternsWithArray:patterns andType:currentType];
        
        for(NSUInteger i=0;i<configuredPatterns.count;i++){
            
            NSArray * resultMatched =  [self checkMatchingItemsWithConfiguredPattern: configuredPatterns[i]];
            
            if(resultMatched!=nil){
                [result addObjectsFromArray:resultMatched];
            }
        }
        
    }
    
    if(result.count>0){
        
        if(self.canRevertUserAction){
            self.moviesCount++;
            
            self.canRevertUserAction = NO;
            
            [self notifyAboutDidUpdateMoviesCount];
            
        }
        
        
        [self deleteItems:result.allObjects];
        [self fillGaps];
        NSLog(@"items to delete %@", result );
        
    } else {
        
        NSLog(@"no has matches");
        
        for(int i=0;i<_verticalItemsCount;i++){
            NSString * str = @"|";
            for(int j=0;j<_horizontalItemsCount;j++){
                str = [str stringByAppendingString: [NSString stringWithFormat:@"%@|",_gameField[j][i]] ] ;
            }
            NSLog(@"%@",str);
        }
        
        
        if(self.canRevertUserAction){
            
            [self revertUserAction];
            
        }else{
            
            [self notifyAboutkEndOfTransitions];
            
            [self checkPotentialMatches];
            
            
        }
        
        
        
        
    }
    
    
}


-(void) checkPotentialMatches {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        
        
        NSMutableArray * verticalPattern1 = [[NSMutableArray alloc] initWithArray:@[[NSNull null],[NSNull null],@"*",[NSNull null]]];
        
        NSMutableArray * verticalPattern2 = [[NSMutableArray alloc] initWithArray:@[[NSNull null],@"*",[NSNull null],[NSNull null]]];
        
        
        NSMutableArray * verticalPattern3 = [[NSMutableArray alloc] initWithObjects:
                                             [[NSMutableArray alloc] initWithArray:@[@"*",[NSNull null],[NSNull null]]],
                                             [[NSMutableArray alloc] initWithArray:@[[NSNull null],@"*",@"*"]],
                                             nil];
        
        
        NSMutableArray * verticalPattern4 = [[NSMutableArray alloc] initWithObjects:
                                             [[NSMutableArray alloc] initWithArray:@[@"*",@"*",         [NSNull null]]],
                                             [[NSMutableArray alloc] initWithArray:@[[NSNull null],[NSNull null],@"*"]],
                                             nil];
        
        
        
        NSMutableArray * verticalPattern5 = [[NSMutableArray alloc] initWithObjects:
                                             [[NSMutableArray alloc] initWithArray:@[[NSNull null],[NSNull null],@"*"]],
                                             [[NSMutableArray alloc] initWithArray:@[@"*",@"*",[NSNull null]]],
                                             nil];
        
        
        NSMutableArray * verticalPattern6 = [[NSMutableArray alloc] initWithObjects:
                                             [[NSMutableArray alloc] initWithArray:@[[NSNull null],@"*",@"*"]],
                                             [[NSMutableArray alloc] initWithArray:@[@"*",[NSNull null],[NSNull null]]],
                                             nil];
        
        
        
        NSMutableArray * verticalPattern7 = [[NSMutableArray alloc] initWithObjects:
                                             [[NSMutableArray alloc] initWithArray:@[[NSNull null],@"*",[NSNull null]]],
                                             [[NSMutableArray alloc] initWithArray:@[@"*",      [NSNull null]   ,@"*"]],
                                             nil];
        
        NSMutableArray * verticalPattern8 = [[NSMutableArray alloc] initWithObjects:
                                             [[NSMutableArray alloc] initWithArray:@[@"*",      [NSNull null]   ,@"*"]],
                                             [[NSMutableArray alloc] initWithArray:@[[NSNull null],@"*",[NSNull null]]],
                                             nil];
        
        
        NSMutableArray * horisontalPattern1 = [[NSMutableArray alloc] initWithObjects:
                                               [[NSMutableArray alloc] initWithArray:@[[NSNull null],[NSNull null],@"*",[NSNull null]]], nil];
        
        NSMutableArray * horisontalPattern2 = [[NSMutableArray alloc] initWithObjects:
                                               [[NSMutableArray alloc] initWithArray:@[[NSNull null],@"*",[NSNull null],[NSNull null]]], nil];
        
        NSMutableArray * horisontalPattern3 = [[NSMutableArray alloc] initWithObjects:
                                               [[NSMutableArray alloc] initWithArray:@[@"*",[NSNull null]]],
                                               [[NSMutableArray alloc] initWithArray:@[[NSNull null],@"*"]],
                                               [[NSMutableArray alloc] initWithArray:@[[NSNull null],@"*"]],
                                               nil];
        
        NSMutableArray * horisontalPattern4 = [[NSMutableArray alloc] initWithObjects:
                                               [[NSMutableArray alloc] initWithArray:@[[NSNull null],@"*"]],
                                               [[NSMutableArray alloc] initWithArray:@[[NSNull null],@"*"]],
                                               [[NSMutableArray alloc] initWithArray:@[@"*",[NSNull null]]],
                                               
                                               nil];
        
        NSMutableArray * horisontalPattern5 = [[NSMutableArray alloc] initWithObjects:
                                               [[NSMutableArray alloc] initWithArray:@[[NSNull null],@"*"]],
                                               [[NSMutableArray alloc] initWithArray:@[@"*",[NSNull null]]],
                                               [[NSMutableArray alloc] initWithArray:@[[NSNull null],@"*"]],
                                               nil];
        
        
        NSMutableArray * horisontalPattern6 = [[NSMutableArray alloc] initWithObjects:
                                               [[NSMutableArray alloc] initWithArray:@[[NSNull null],@"*"]],
                                               [[NSMutableArray alloc] initWithArray:@[@"*",[NSNull null]]],
                                               [[NSMutableArray alloc] initWithArray:@[@"*",[NSNull null]]],
                                               nil];
        
        NSMutableArray * horisontalPattern7 = [[NSMutableArray alloc] initWithObjects:
                                               [[NSMutableArray alloc] initWithArray:@[@"*",[NSNull null]]],
                                               [[NSMutableArray alloc] initWithArray:@[[NSNull null],@"*"]],
                                               [[NSMutableArray alloc] initWithArray:@[@"*",[NSNull null]]],
                                               nil];
        
        NSMutableArray * horisontalPattern8 = [[NSMutableArray alloc] initWithObjects:
                                               [[NSMutableArray alloc] initWithArray:@[@"*",[NSNull null]]],
                                               [[NSMutableArray alloc] initWithArray:@[@"*",[NSNull null]]],
                                               [[NSMutableArray alloc] initWithArray:@[[NSNull null],@"*"]],
                                               nil];
        
        
        
        NSMutableArray * squarePattern1 = [[NSMutableArray alloc] initWithObjects:
                                           [[NSMutableArray alloc] initWithArray:@[[NSNull null],     [NSNull null],@"*"]],
                                           [[NSMutableArray alloc] initWithArray:@[[NSNull null],     @"*",         [NSNull null]]],
                                           nil];
        
        NSMutableArray * squarePattern2 = [[NSMutableArray alloc] initWithObjects:
                                           [[NSMutableArray alloc] initWithArray:@[[NSNull null],         @"*",[NSNull null]]],
                                           [[NSMutableArray alloc] initWithArray:@[[NSNull null],[NSNull null],@"*"]],
                                           nil];
        NSMutableArray * squarePattern3 = [[NSMutableArray alloc] initWithObjects:
                                           [[NSMutableArray alloc] initWithArray:@[[NSNull null],   @"*",         [NSNull null]]],
                                           [[NSMutableArray alloc] initWithArray:@[@"*",            [NSNull null],[NSNull null]]],
                                           nil];
        
        NSMutableArray * squarePattern4 = [[NSMutableArray alloc] initWithObjects:
                                           [[NSMutableArray alloc] initWithArray:@[@"*"         ,[NSNull null],[NSNull null]]],
                                           [[NSMutableArray alloc] initWithArray:@[[NSNull null],@"*",         [NSNull null]]],
                                           nil];
        
        
        NSMutableArray * squarePattern5 = [[NSMutableArray alloc] initWithObjects:
                                           [[NSMutableArray alloc] initWithArray:@[[NSNull null],[NSNull null]]],
                                           [[NSMutableArray alloc] initWithArray:@[@"*"         ,[NSNull null]]],
                                           [[NSMutableArray alloc] initWithArray:@[[NSNull null],@"*"]],
                                           nil];
        
        NSMutableArray * squarePattern6 = [[NSMutableArray alloc] initWithObjects:
                                           [[NSMutableArray alloc] initWithArray:@[@"*"         , [NSNull null]]],
                                           [[NSMutableArray alloc] initWithArray:@[[NSNull null],@"*"]],
                                           [[NSMutableArray alloc] initWithArray:@[[NSNull null],[NSNull null]]],
                                           nil];
        
        
        
        
        
        
        
        NSMutableArray * patterns = [[NSMutableArray alloc] initWithArray:@[squarePattern1,squarePattern2,squarePattern3,
                                                                            squarePattern4,squarePattern5,squarePattern6,
                                                                            verticalPattern1,verticalPattern2,verticalPattern3,verticalPattern4,verticalPattern5,verticalPattern6,verticalPattern7,verticalPattern8,
                                                                            horisontalPattern1,horisontalPattern2,horisontalPattern3,
                                                                            horisontalPattern4,horisontalPattern5,horisontalPattern6,horisontalPattern7,horisontalPattern8
                                                                            ] copyItems:NO];
        
        
        NSMutableArray * result = [NSMutableArray new];
        
        BOOL isFinded = NO;
        
        
        
        for(NSUInteger currentType=1;currentType<=self.itemTypesCount;currentType++){
            if(isFinded)break;
            NSArray * configuredPatterns = [self configurePatternsWithArray:patterns andType:currentType];
            
            for(NSUInteger i=0;i<configuredPatterns.count;i++){
                NSArray * resultMatched =  [self checkMatchingItemsWithConfiguredPattern: configuredPatterns[i] supportMultiplyMatches:NO includeSearchedElemetsOnly:YES];
                
                
                
                if(resultMatched!=nil){
                    [result addObjectsFromArray:resultMatched];
                    isFinded = YES;
                    
                    
                    for(NSDIJStruct * tempIJ in [result copy]){
                        
                        if([self.gameField[tempIJ.i][tempIJ.j] unsignedIntegerValue]!=currentType){
                            [result removeObject:tempIJ];
                        }
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                    break;
                }
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(result.count>0){
                NSLog(@"potential match : %@",result);
                [self notifyAboutDidFindPotentialMatch:result];
            }else{
                [self notifyAboutDidDetectGameOver];
            }
        });
        
    });
    
}


-(NSUInteger) calculatePatternJMaxSize : (NSMutableArray *) pattern{
    
    //  if(pattern.count == 1){ return 1;}
    
    NSUInteger result = 0;
    
    for(int i=0;i<pattern.count;i++){
        
        NSUInteger tmpResult = 0;
        
        if([pattern[i] isKindOfClass:[NSArray class]]){
            
            NSMutableArray * __weak subPatternArray = pattern[i];
            
            tmpResult = subPatternArray.count;
            
        }else{
            
            tmpResult = 1;
        }
        
        if(tmpResult > result){
            
            result = tmpResult;
        }
        
    }
    
    return result;
}


- (BOOL) compareItemsWithPatternItem:(id) patternItem
                       gameFieldItem:(NSNumber *) gameFieldItem{
    
    if([patternItem isKindOfClass:[NSString class]]){
        if( [(NSString *) patternItem isEqualToString:@"*"]) return YES;
    }
    
    if([patternItem isKindOfClass:[NSNumber class]]){
        return [(NSNumber *)patternItem isEqualToNumber:gameFieldItem]
        || ([patternItem unsignedIntegerValue] == [gameFieldItem unsignedIntegerValue]);
    }
    
    return NO;
    
}

-(NSArray *) checkMatchingItemsWithConfiguredPattern:(NSMutableArray *)pattern{
    return [self checkMatchingItemsWithConfiguredPattern:(NSMutableArray *)pattern supportMultiplyMatches:YES includeSearchedElemetsOnly:NO];
}

-(NSArray *) checkMatchingItemsWithConfiguredPattern:(NSMutableArray *)pattern supportMultiplyMatches:(BOOL) supportMultiplyMatches includeSearchedElemetsOnly:(BOOL) isIncludeSearchedElemetsOnly{
    
    NSMutableArray * result = [NSMutableArray new];
    
    NSUInteger jPatternMaxSize = [self calculatePatternJMaxSize:pattern];
    
    
    for(NSUInteger i = 0; i <= (self.horizontalItemsCount - pattern.count); i++){
        for(NSUInteger j = 0; j <= (self.verticalItemsCount-jPatternMaxSize);j++){
            
            BOOL isPatternMatched = YES;
            
            NSMutableArray * checkedItems = [[NSMutableArray alloc] init];
            
            for(NSUInteger patternI = 0;patternI<pattern.count;patternI++){
                
                if([pattern[patternI] isKindOfClass:[NSArray class]]){
                    
                    for(NSUInteger patternJ = 0;patternJ < jPatternMaxSize;patternJ++){
                        
                        
                        isPatternMatched = [self compareItemsWithPatternItem:pattern[patternI][patternJ] gameFieldItem:self.gameField[i+patternI][j+patternJ]] && isPatternMatched;
                        
                        
                        if(!(isIncludeSearchedElemetsOnly && [pattern[patternI][patternJ] isKindOfClass:[NSString class]])){
                            [checkedItems addObject:[[NSDIJStruct alloc] initWithI:i+patternI andJ:j+patternJ]];
                        }
                        
                    }
                }else{
                    
                    isPatternMatched = [self compareItemsWithPatternItem:pattern[patternI] gameFieldItem:self.gameField[i+patternI][j]] && isPatternMatched;
                    
                    if(!(isIncludeSearchedElemetsOnly && [pattern[patternI] isKindOfClass:[NSString class]])){
                        [checkedItems addObject:[[NSDIJStruct alloc] initWithI:i+patternI andJ:j]];
                    }
                }
                
            }
            
            NSLog(@"checked items %@",[checkedItems description]);
            
            if(isPatternMatched){
                
                [result addObjectsFromArray:checkedItems];
                
                if(!supportMultiplyMatches){
                    
                    
                    
                    
                    
                    
                    
                    return result;
                }
                
            }
            
            
        }
    }
    
    if(result.count>0){
        
        NSLog(@"matched items in pattern: %@ result: %@",pattern,result);
        
        return result;
    }
    return nil;
}



- (NSArray *) configurePatternsWithArray:(NSMutableArray * )arrayPatterns andType:(NSUInteger) type{
    
    NSLog(@"configure pattering with type %ld pattern before configure: %@",(long)type,arrayPatterns.description);
    
    
    for(NSUInteger i=0;i<arrayPatterns.count;i++)
    {
        for(NSUInteger j=0;j<((NSMutableArray *)arrayPatterns[i]).count;j++){
            if( [[[arrayPatterns objectAtIndex:i]firstObject] isKindOfClass:[NSArray class]]  ){
                
                for(NSUInteger k=0;k<((NSMutableArray *) [[arrayPatterns objectAtIndex:i] objectAtIndex:j]).count;k++){
                    NSMutableArray * pattern = (NSMutableArray *)arrayPatterns[i][j];
                    
                    if(! ([pattern[k] isKindOfClass:[NSString class]])){
                        pattern[k] = @(type);
                    }
                    
                    
                }
                
            }else{
                NSMutableArray * pattern = (NSMutableArray *)arrayPatterns[i];
                if(!([pattern[j] isKindOfClass:[NSString class]])){
                    pattern[j] = @(type);
                }
            }
        }
    }
    
    NSLog(@"array after configure %@",arrayPatterns.description);
    return arrayPatterns;
}

- (void)fillGaps {
    NSMutableArray *newItemTransitions = [NSMutableArray new];
    for (NSUInteger i = 0; i < self.horizontalItemsCount; i++) {
        for (NSInteger j = self.verticalItemsCount - 1; j >= 0; j--) {
            if (self.gameField[i][j] == [NSNull null]) {
                
                NSDGameItemTransition *itemTransition = [NSDGameItemTransition new];
                
                itemTransition.from = [[NSDIJStruct alloc] init];
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

- (void)deleteItems:(NSArray*)matchingSequences {
    
    
    for(NSDIJStruct * tempStruct in matchingSequences){
        
        
        if(self.gameField[tempStruct.i][tempStruct.j]!=[NSNull null]){
            
            self.gameField[tempStruct.i][tempStruct.j]=[NSNull null];
        }
        
        
        
    }
    
    
    
    [self notifyAboutItemsDeletion:matchingSequences];
    
    self.userScore += matchingSequences.count * NSDGameItemScoreCost;
    
    [self notifyAboutDidUpdateUserScore];
    
}

- (void)revertUserAction {
    
    NSMutableArray * newItemTransitions = [[NSMutableArray alloc] initWithCapacity:2];
    
    newItemTransitions[0] = [[NSDGameItemTransition alloc] initWithFrom:self.lastUserSwap.to to:self.lastUserSwap.from type:[self.gameField[self.lastUserSwap.to.i][self.lastUserSwap.to.j] unsignedIntegerValue]];
    
    newItemTransitions[1] = [[NSDGameItemTransition alloc] initWithFrom:self.lastUserSwap.from to:self.lastUserSwap.to type:[self.gameField[self.lastUserSwap.from.i][self.lastUserSwap.from.j] unsignedIntegerValue]];
    
    [self notifyAboutItemsMovement:newItemTransitions];
    
    
    id tmp = self.gameField[self.lastUserSwap.from.i][self.lastUserSwap.from.j];
    self.gameField[self.lastUserSwap.from.i][self.lastUserSwap.from.j] = self.gameField[self.lastUserSwap.to.i][self.lastUserSwap.to.j];
    self.gameField[self.lastUserSwap.to.i][self.lastUserSwap.to.j] = tmp;
    
    
    self.canRevertUserAction=NO;
    
    [self notifyAboutkEndOfTransitions];
    
}



#pragma mark - Notifications



-(void) notifyAboutDidDetectGameOver{
    
    NSNotification * notification = [NSNotification notificationWithName:NSDDidDetectGameOver object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}


-(void) notifyAboutDidFindPotentialMatch:(NSArray *) items{
    
    NSNotification *notification = [NSNotification notificationWithName:NSDDidFindPotentialMathed
                                                                 object:nil
                                                               userInfo:@{kNSDGameItems : items}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
}

- (void)notifyAboutDidUpdateUserScore{
    NSNotification *notification = [NSNotification notificationWithName:NSDDidUpdateUserScore
                                                                 object:nil
                                                               userInfo:@{ kNSDUserScore : @(self.userScore)}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

-(void) notifyAboutDidUpdateMoviesCount{
    NSNotification *notification = [NSNotification notificationWithName:NSDDidUpdateMoviesCount
                                                                 object:nil
                                                               userInfo:@{ kNSDMoviesCount : @(self.moviesCount)}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

- (void)notifyAboutkEndOfTransitions{
    NSNotification *notification = [NSNotification notificationWithName:NSDEndOfTransitions
                                                                 object:nil
                                                               userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

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
