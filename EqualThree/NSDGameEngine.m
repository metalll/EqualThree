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


@property NSUInteger mutex;

@property NSMutableArray * itemsToDelete;


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
    return result;
}

- (void)applyUserAction {
    //todo: do stuff
    //todo: notifyAboutItemsMovement
    self.canRevertUserAction = YES;
    [self checkMatchingItems];
}

- (void)checkMatchingItems {

    
    NSMutableArray * horizontalPattern = [[NSMutableArray alloc] initWithArray:@[ [NSNull null],[NSNull null],[NSNull null]]] ;
     /*
     
     ###
     
     */
    
    NSMutableArray * verticalPatternEnded =[NSMutableArray new];
  
    NSMutableArray * verticalPattern = [NSMutableArray new];
    [verticalPattern addObject:[NSMutableArray new]];
    [verticalPattern addObject:[NSMutableArray new]];
    [verticalPattern addObject:[NSMutableArray new]];
    
    [verticalPatternEnded addObject:verticalPattern];
    
  
    /*
        #
        #
        #
     */
    
    NSMutableArray * squarePattern = [NSMutableArray new] ;
    
    NSMutableArray * tqP0 =  [NSMutableArray new];
    [tqP0 addObject:[NSNull null]];
    [tqP0 addObject:[NSNull null]];
    NSMutableArray * tqP1 =  [NSMutableArray new];
    [tqP1 addObject:[NSNull null]];
    [tqP1 addObject:[NSNull null]];
    
    
    [squarePattern addObject:tqP0];
    [squarePattern addObject:tqP1];
                                
    /*
     
        ##
        ##
     
     */
    
    
  //  NSMutableArray * patterns = [[NSMutableArray alloc] initWithArray:@[horizontalPattern,verticalPattern,squarePattern]];
    
    NSMutableArray * patterns = [[NSMutableArray alloc] initWithArray:@[verticalPatternEnded,horizontalPattern,squarePattern]];
    
    
    self.mutex = 0;
    self.itemsToDelete = [NSMutableArray new];
    
    
    for(NSUInteger currentType=0;currentType<self.itemTypesCount;currentType++){
       NSArray * configuredPatterns = [self configurePatternsWithArray:[patterns copy] andType:currentType];
    for(NSUInteger i=0;i<configuredPatterns.count;i++){
        
        NSArray * resultMatched =  [self checkMatchingItemsWithConfiguredPattern: configuredPatterns[i]];
        
        if(resultMatched!=nil){
            [self.itemsToDelete addObjectsFromArray:resultMatched];
        
        }
    }
    
}
    
    if(self.itemsToDelete.count>0){
        
        
        
    [self deleteItems:self.itemsToDelete];
    }
    NSLog(@"items to delete %@",self.itemsToDelete.description);
    
}
        
        

-(NSArray *) checkMatchingItemsWithConfiguredPattern:(NSMutableArray *)configurePattern{
    //calculate is global queue
   
        //assing in local var
        NSArray * template = configurePattern;
      
        
        //calculate max template size
        NSUInteger templateWidth = template.count;
        NSUInteger templateHeight = 0;
        
        NSMutableArray * result = [NSMutableArray new];
        
        
        for(NSUInteger ti=0;ti<templateWidth;ti++){
            
            if([template[ti] isKindOfClass:[NSArray class]]){
                NSUInteger tempTemplateHeight = ((NSArray *) template[ti]).count;
                if(templateHeight<tempTemplateHeight){
                    templateHeight = tempTemplateHeight;
                }
                
            }else{
                if(templateHeight<1){
                    templateHeight = 1;
                }
            }
        }
    
    
    
    
        
        
        //checkMathed
        
        for(NSUInteger i=0;i<(self.verticalItemsCount-templateWidth+1);i++){
            for(NSUInteger j=0;j<(self.horizontalItemsCount-templateHeight+1);j++){
            
                BOOL isMatched = YES;
                
                NSMutableArray * checkedItems = [[NSMutableArray alloc] init];
        
                for(NSUInteger ti = 0;ti<templateWidth;ti++){
                    for(NSUInteger tj = 0;tj<templateHeight;tj++){
                        
                        
                        
                        if([template[ti] isKindOfClass:[NSArray class]]){
               
                            BOOL previosMathed = isMatched;
                            if([template[ti][tj]isKindOfClass:[NSString class]]){
                                isMatched = previosMathed && YES;
                            }else{
                                
                                
                             
                                
                            isMatched = ([self.gameField[i+ti][j+tj] unsignedIntegerValue] == [template[ti][tj] unsignedIntegerValue]) && previosMathed && YES;
                            
                              
                            [checkedItems addObject:[[NSDIJStruct alloc] initWithI:i+ti andJ:j+tj]];    
                        }
                        }
                        else{
                            BOOL previosMathed = isMatched;
                            
                            if([template[ti] isKindOfClass:[NSString class]]){
                                isMatched = previosMathed && YES;
                                }else{
                                    
                                    
                            isMatched = ([self.gameField[i+ti][j+tj] unsignedIntegerValue] == [template[ti] unsignedIntegerValue]) && previosMathed && YES ;
                            [checkedItems addObject:[[NSDIJStruct alloc] initWithI:i+ti andJ:j+tj]];
                            
                            }
                     
                        }
                    }
                
                    
                }
                
                NSLog(@"checked items %@",[checkedItems description]);
                
                if(isMatched){
                    [result addObjectsFromArray:checkedItems];
                }
             
            }
        }
        
        
        
        
        
    
                
                if(result.count>0){
                    NSLog(@"temp result: %@",result);
                    
                    return result;
                }
                else{
                
                    NSLog(@"temp result: %@",result);
                    
                    return nil;
                    
                }
    
            

    return nil;
}


- (NSArray *) configurePatternsWithArray:(NSMutableArray * )arrayPatterns andType:(NSUInteger) type{


    NSLog(@"array before configure %@",arrayPatterns.description);
    
    
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
                    itemTransition.y0 =  - 1 ;
                    itemTransition.type = newItemType;
                }
                
                [newItemTransitions addObject:itemTransition];
            }
        }
    }
    [self checkMatchingItems];
    [self notifyAboutItemsMovement:newItemTransitions];
   
}

- (void)deleteItems:(NSArray*)matchingSequences {
   
    
    for(NSDIJStruct * tempStruct in matchingSequences){
        
        
        if(self.gameField[tempStruct.i][tempStruct.j]!=[NSNull null]){
            
            
        //    [self.gameField[tempStruct.i][tempStruct.j]];
            
            
            
            self.gameField[tempStruct.i][tempStruct.j]=[NSNull null];
            
            
            
            
        }
        
        
        
    }
    
     [self fillGaps];
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
