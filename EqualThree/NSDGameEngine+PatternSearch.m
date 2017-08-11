//
//  NSDGameEngine+PatternSearch.m
//  EqualThree
//
//  Created by NSD on 10.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGameEngine+PatternSearch.h"

@implementation NSDGameEngine (PatternSearch)

- (NSArray *)configurePatternsWithArray:(NSMutableArray * )arrayPatterns
                                andType:(NSUInteger)type{
    
#ifdef DEBUG
    NSLog(@"configure pattering with type %ld pattern before configure: %@",(long)type,arrayPatterns.description);
#endif
    
    for(NSUInteger i = 0; i < arrayPatterns.count;i++){
        
        for(NSUInteger j = 0; j < ((NSMutableArray *)arrayPatterns[i]).count; j++){
            
            if([[[arrayPatterns objectAtIndex:i] firstObject] isKindOfClass:[NSArray class]]) {
                
                for(NSUInteger k = 0;k < ((NSMutableArray *) [[arrayPatterns objectAtIndex:i] objectAtIndex:j]).count; k++){
                    
                    NSMutableArray *pattern = (NSMutableArray *)arrayPatterns[i][j];
                    
                    if(! ([pattern[k] isKindOfClass:[NSString class]])){
                        
                        pattern[k] = @(type);
                    }
                }
            }else{
                
                NSMutableArray *pattern = (NSMutableArray *) arrayPatterns[i];
                
                if(!([pattern[j] isKindOfClass:[NSString class]])){
                    
                    pattern[j] = @(type);
                }
            }
        }
    }
    
#ifdef DEBUG
    NSLog(@"array after configure %@",arrayPatterns.description);
#endif
    
    return arrayPatterns;
}

- (NSUInteger)calculatePatternJMaxSize:(NSMutableArray *)pattern{
    
    NSUInteger result = 0;
    
    for(NSUInteger i = 0; i < pattern.count; i++){
        
        NSUInteger tmpResult = 0;
        
        if([pattern[i] isKindOfClass:[NSArray class]]){
            
            NSMutableArray *__weak subPatternArray = pattern[i];
            
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

- (BOOL)compareItemsWithPatternItem:(id)patternItem
                      gameFieldItem:(NSNumber *)gameFieldItem{
    
    if([patternItem isKindOfClass:[NSString class]]){
        if([(NSString *) patternItem isEqualToString:ANY]) return YES;
    }
    
    if([patternItem isKindOfClass:[NSNumber class]]){
        return [(NSNumber *)patternItem isEqualToNumber:gameFieldItem] || ([patternItem unsignedIntegerValue] == [gameFieldItem unsignedIntegerValue]);
    }
    
    return NO;
}

- (NSArray *)checkMatchingPatternWithConfiguredPattern:(NSMutableArray *)pattern{
    return [self checkMatchingPatternWithConfiguredPattern:(NSMutableArray *)pattern
                                    supportMultiplyMatches:YES];
}

- (NSArray *)checkMatchingPatternWithConfiguredPattern:(NSMutableArray *)pattern
                                supportMultiplyMatches:(BOOL)supportMultiplyMatches{
    
    NSMutableArray * result = [NSMutableArray new];
    
    NSUInteger jPatternMaxSize = [self calculatePatternJMaxSize:pattern];
    
    for(NSUInteger i = 0; i <= (self.horizontalItemsCount - pattern.count); i++){
        for(NSUInteger j = 0; j <= (self.verticalItemsCount-jPatternMaxSize); j++){
            
            BOOL isPatternMatched = YES;
            
            NSMutableArray *checkedItems = [[NSMutableArray alloc] init];
            
            for(NSUInteger patternI = 0; patternI < pattern.count; patternI++){
                
                if([pattern[patternI] isKindOfClass:[NSArray class]]){
                    
                    for(NSUInteger patternJ = 0;patternJ < jPatternMaxSize; patternJ++){
                        
                        isPatternMatched = [self compareItemsWithPatternItem:pattern[patternI][patternJ] gameFieldItem:self.gameField[i+patternI][j+patternJ]] && isPatternMatched;
                        
                        
                        if(!([pattern[patternI][patternJ] isKindOfClass:[NSString class]] && [pattern[patternI][patternJ] isEqualToString:ANY])){
                            
                            [checkedItems addObject:[[NSDIJStruct alloc] initWithI:i+patternI andJ:j+patternJ]];
                        }
                    }
                }else{
                    
                    isPatternMatched = [self compareItemsWithPatternItem:pattern[patternI] gameFieldItem:self.gameField[i+patternI][j]] && isPatternMatched;
                    
                    if(!([pattern[patternI] isKindOfClass:[NSString class]] && [pattern[patternI] isEqualToString:ANY])){
                        
                        [checkedItems addObject:[[NSDIJStruct alloc] initWithI:i + patternI andJ:j]];
                    }
                }
            }
            
#ifdef DEBUG
            NSLog(@"checked items %@",[checkedItems description]);
#endif
            if(isPatternMatched){
                
                [result addObjectsFromArray:checkedItems];
                
                if(!supportMultiplyMatches){
                    return result;
                }
                
            }
        }
    }
    
    if(result.count>0){
        
#ifdef DEBUG
        NSLog(@"matched items in pattern: %@ result: %@",pattern,result);
#endif
        
        return result;
    }
    
    return nil;
}

@end
