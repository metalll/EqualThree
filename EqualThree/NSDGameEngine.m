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

@property NSDSwap * lastUserSwap;

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



- (void)swapItemsWithSwap:(NSDSwap *) swap{
    
#ifdef _DEBUG
    
    NSLog("swap items %@",swap);
    
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
    //todo: do stuff
    //todo: notifyAboutItemsMovement
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
        
        
        
        
        
        [self checkPotentialMatches];
        
        
    }
   

}
        

-(void) checkPotentialMatches {

    
    //to do


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
                        
                        
                        [checkedItems addObject:[[NSDIJStruct alloc] initWithI:i+patternI andJ:j+patternJ]];
                        
                    }
                }else{
                    
                    isPatternMatched = [self compareItemsWithPatternItem:pattern[patternI] gameFieldItem:self.gameField[i+patternI][j]] && isPatternMatched;
                    [checkedItems addObject:[[NSDIJStruct alloc] initWithI:i+patternI andJ:j]];
                }
                
            }
            
                NSLog(@"checked items %@",[checkedItems description]);
                
                if(isPatternMatched){
                    
                    [result addObjectsFromArray:checkedItems];
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
                    
                    if(!([pattern[k] isKindOfClass:[NSString class]])){
                    pattern[k] = @(type);
                    }
                    
                   
                }

            }else{
                NSMutableArray * pattern = (NSMutableArray *)arrayPatterns[i];
                if(!([pattern[i] isKindOfClass:[NSString class]])){
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
