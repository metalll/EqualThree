//
//  NSDGameEngine+CheckPermissibleStroke.m
//  EqualThree
//
//  Created by NSD on 10.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGameEngine+CheckPermissibleStroke.h"
#import "NSDGameEngine+PatternSearch.h"
#import "NSDGameEngine+Notifications.h"

@implementation NSDGameEngine (CheckPermissibleStroke)

- (void)checkPermissibleStroke{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSMutableArray *verticalPattern1 = [[NSMutableArray alloc] initWithArray:@[X, X, ANY, X]];
        
        NSMutableArray *verticalPattern2 = [[NSMutableArray alloc] initWithArray:@[X, ANY, X, X]];
        
        NSMutableArray *verticalPattern3 = [[NSMutableArray alloc] initWithObjects:
                                            [[NSMutableArray alloc] initWithArray:@[ANY, X, X]],
                                            [[NSMutableArray alloc] initWithArray:@[X, ANY, ANY]],
                                            nil];
        
        NSMutableArray *verticalPattern4 = [[NSMutableArray alloc] initWithObjects:
                                            [[NSMutableArray alloc] initWithArray:@[ANY, ANY, X]],
                                            [[NSMutableArray alloc] initWithArray:@[X, X, ANY]],
                                            nil];
        
        NSMutableArray *verticalPattern5 = [[NSMutableArray alloc] initWithObjects:
                                            [[NSMutableArray alloc] initWithArray:@[X, X, ANY]],
                                            [[NSMutableArray alloc] initWithArray:@[ANY, ANY, X]],
                                            nil];
        
        NSMutableArray *verticalPattern6 = [[NSMutableArray alloc] initWithObjects:
                                            [[NSMutableArray alloc] initWithArray:@[X, ANY, ANY]],
                                            [[NSMutableArray alloc] initWithArray:@[ANY, X, X]],
                                            nil];
        
        NSMutableArray *verticalPattern7 = [[NSMutableArray alloc] initWithObjects:
                                            [[NSMutableArray alloc] initWithArray:@[X, ANY, X]],
                                            [[NSMutableArray alloc] initWithArray:@[ANY, X, ANY]],
                                            nil];
        
        NSMutableArray *verticalPattern8 = [[NSMutableArray alloc] initWithObjects:
                                            [[NSMutableArray alloc] initWithArray:@[ANY, X, ANY]],
                                            [[NSMutableArray alloc] initWithArray:@[X, ANY, X]],
                                            nil];
        
        NSMutableArray *horisontalPattern1 = [[NSMutableArray alloc] initWithObjects:
                                              [[NSMutableArray alloc] initWithArray:@[X, X, ANY, X]],
                                              nil];
        
        NSMutableArray *horisontalPattern2 = [[NSMutableArray alloc] initWithObjects:
                                              [[NSMutableArray alloc] initWithArray:@[X, ANY, X, X]],
                                              nil];
        
        NSMutableArray *horisontalPattern3 = [[NSMutableArray alloc] initWithObjects:
                                              [[NSMutableArray alloc] initWithArray:@[ANY, X]],
                                              [[NSMutableArray alloc] initWithArray:@[X, ANY]],
                                              [[NSMutableArray alloc] initWithArray:@[X, ANY]],
                                              nil];
        
        NSMutableArray *horisontalPattern4 = [[NSMutableArray alloc] initWithObjects:
                                              [[NSMutableArray alloc] initWithArray:@[X, ANY]],
                                              [[NSMutableArray alloc] initWithArray:@[X, ANY]],
                                              [[NSMutableArray alloc] initWithArray:@[ANY, X]],
                                              nil];
        
        NSMutableArray *horisontalPattern5 = [[NSMutableArray alloc] initWithObjects:
                                              [[NSMutableArray alloc] initWithArray:@[X, ANY]],
                                              [[NSMutableArray alloc] initWithArray:@[ANY, X]],
                                              [[NSMutableArray alloc] initWithArray:@[X, ANY]],
                                              nil];
        
        
        NSMutableArray *horisontalPattern6 = [[NSMutableArray alloc] initWithObjects:
                                              [[NSMutableArray alloc] initWithArray:@[X, ANY]],
                                              [[NSMutableArray alloc] initWithArray:@[ANY, X]],
                                              [[NSMutableArray alloc] initWithArray:@[ANY, X]],
                                              nil];
        
        NSMutableArray *horisontalPattern7 = [[NSMutableArray alloc] initWithObjects:
                                              [[NSMutableArray alloc] initWithArray:@[ANY, X]],
                                              [[NSMutableArray alloc] initWithArray:@[X, ANY]],
                                              [[NSMutableArray alloc] initWithArray:@[ANY, X]],
                                              nil];
        
        NSMutableArray *horisontalPattern8 = [[NSMutableArray alloc] initWithObjects:
                                              [[NSMutableArray alloc] initWithArray:@[ANY, X]],
                                              [[NSMutableArray alloc] initWithArray:@[ANY, X]],
                                              [[NSMutableArray alloc] initWithArray:@[X, ANY]],
                                              nil];
        
        NSMutableArray *squarePattern1 = [[NSMutableArray alloc] initWithObjects:
                                          [[NSMutableArray alloc] initWithArray:@[X, X, ANY]],
                                          [[NSMutableArray alloc] initWithArray:@[X, ANY, X]],
                                          nil];
        
        NSMutableArray *squarePattern2 = [[NSMutableArray alloc] initWithObjects:
                                          [[NSMutableArray alloc] initWithArray:@[X, ANY, X]],
                                          [[NSMutableArray alloc] initWithArray:@[X, X, ANY]],
                                          nil];
        
        NSMutableArray *squarePattern3 = [[NSMutableArray alloc] initWithObjects:
                                          [[NSMutableArray alloc] initWithArray:@[X, ANY, X]],
                                          [[NSMutableArray alloc] initWithArray:@[ANY, X, X]],
                                          nil];
        
        NSMutableArray *squarePattern4 = [[NSMutableArray alloc] initWithObjects:
                                          [[NSMutableArray alloc] initWithArray:@[ANY, X, X]],
                                          [[NSMutableArray alloc] initWithArray:@[X, ANY, X]],
                                          nil];
        
        NSMutableArray *squarePattern5 = [[NSMutableArray alloc] initWithObjects:
                                          [[NSMutableArray alloc] initWithArray:@[X, X]],
                                          [[NSMutableArray alloc] initWithArray:@[ANY, X]],
                                          [[NSMutableArray alloc] initWithArray:@[X, ANY]],
                                          nil];
        
        NSMutableArray *squarePattern6 = [[NSMutableArray alloc] initWithObjects:
                                          [[NSMutableArray alloc] initWithArray:@[ANY, X]],
                                          [[NSMutableArray alloc] initWithArray:@[X, ANY]],
                                          [[NSMutableArray alloc] initWithArray:@[X, X]],
                                          nil];
        
        NSMutableArray *patterns = [[NSMutableArray alloc] initWithArray:
                                    @[ squarePattern1, squarePattern2, squarePattern3, squarePattern4, squarePattern5, squarePattern6, verticalPattern1, verticalPattern2, verticalPattern3, verticalPattern4, verticalPattern5, verticalPattern6, verticalPattern7, verticalPattern8, horisontalPattern1,horisontalPattern2, horisontalPattern3, horisontalPattern4, horisontalPattern5, horisontalPattern6, horisontalPattern7, horisontalPattern8 ] copyItems:NO];
        
        NSMutableArray *result = [NSMutableArray new];
        
        BOOL isFinded = NO;
        
        for(NSUInteger currentType = 1; currentType <= self.itemTypesCount; currentType++){
            
            if(isFinded){
                break;
            }
            
            NSArray *configuredPatterns = [self configurePatternsWithArray:patterns andType:currentType];
            
            for(NSUInteger i=0;i<configuredPatterns.count;i++){
                
                NSArray *resultMatched =  [self checkMatchingPatternWithConfiguredPattern:configuredPatterns[i]
                                                                   supportMultiplyMatches:NO];
                
                if(resultMatched!=nil) {
                    
                    [result addObjectsFromArray:resultMatched];
                    
                    isFinded = YES;
                    
                    break;
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(result.count>0){
                
#ifdef DEBUG
                NSLog(@"permissible stroke : %@",result);
#endif
                
                [self notifyAboutDidFindPermissibleStroke:result];
            }else{
                
                [self notifyAboutDidDetectGameOver];
            }
        });
    });
}


@end
