//
//  NSDGameEngine+PatternSearch.h
//  EqualThree
//
//  Created by NSD on 10.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGameEngine.h"

#define X [NSNull null]
#define ANY @"*"

@interface NSDGameEngine (PatternSearch)

- (NSArray *) configurePatternsWithArray:(NSMutableArray *)arrayPatterns
                                 andType:(NSUInteger)type;

- (NSUInteger) calculatePatternJMaxSize:(NSMutableArray *)pattern;

- (BOOL) compareItemsWithPatternItem:(id) patternItem
                       gameFieldItem:(NSNumber *)gameFieldItem;

- (NSArray *) checkMatchingPatternWithConfiguredPattern:(NSMutableArray *)pattern;

- (NSArray *) checkMatchingPatternWithConfiguredPattern:(NSMutableArray *)pattern
                                 supportMultiplyMatches:(BOOL)supportMultiplyMatches;

@end
