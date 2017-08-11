//
//  NSDIJStruct.m
//  EqualThree
//
//  Created by NSD on 24.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDIJStruct.h"

@implementation NSDIJStruct

#pragma mark - Init

- (instancetype)initWithI:(NSUInteger)i
                     andJ:(NSUInteger)j{
    
    self = [super init];
    
    if (self) {
        
        self.i = i;
        self.j = j;
    }
    
    return self;
}

- (BOOL)isEqual:(id)other{
    
    BOOL isEqual = NO;
    
    NSDIJStruct *castedOther = (NSDIJStruct *)other;
    
    isEqual = (castedOther.i == self.i) && (castedOther.j == self.j);
    
    return isEqual ;
}

- (NSUInteger)hash{
    
    return (self.i * 2) + (self.j * 5);
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"-| item at i: %ld j: %ld |- ", (long)self.i, (long)self.j];
}

@end
