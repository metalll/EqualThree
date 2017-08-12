//
//  NSDGameItemTransition.m
//  EqualThree
//
//  Created by NSD on 20.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGameItemTransition.h"

NSString * const kNSDType = @"kNSDType";
NSString * const kNSDAnimationDuration = @"kNSDAnimationDuration";


float const defaultAnimationDuration = 0.25f;

@implementation NSDGameItemTransition


#pragma mark - Init

- (instancetype) initWithFrom:(NSDIJStruct *) from
                           to:(NSDIJStruct *) to
                         type:(NSDGameItemType)type{
    
    return [self initWithFrom:from to:to type:type animationDuration:defaultAnimationDuration];
}

- (instancetype) initWithFrom:(NSDIJStruct *) from
                           to:(NSDIJStruct *) to
                         type:(NSDGameItemType)type
            animationDuration:(float) animationDuration{
    
    
    self = [super initSwapWithFrom:from to:to];
    
    if(self){
        
        self.type = type;
        self.animationDuration = animationDuration;
    }
    
    return self;
}

#pragma mark - Description

-(NSString *)description{
    
    NSString *description = [NSString stringWithFormat:@" from : %@ to: %@ type: %ld, animation duration: %f",self.from,self.to,(long)self.type,self.animationDuration ];
    
    return description;
}

#pragma mark - Coding

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:@(self.type) forKey:kNSDType];
    [aCoder encodeObject:@(self.animationDuration) forKey:kNSDAnimationDuration];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if(self){
        
        self.animationDuration = [[aDecoder decodeObjectForKey:kNSDAnimationDuration] floatValue];
        self.type = [[aDecoder decodeObjectForKey:kNSDType] unsignedIntegerValue];
    }
    
    return self;
}

@end
