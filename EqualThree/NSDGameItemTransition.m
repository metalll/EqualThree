//
//  NSDGameItemTransition.m
//  EqualThree
//
//  Created by NSD on 20.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGameItemTransition.h"

float const defaultAnimationDuration = 0.4f;

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

    NSString * description = [NSString stringWithFormat:@" from : %@ to: %@ type: %ld, animation duration: %f",self.from,self.to,(long)self.type,self.animationDuration ];
    
    return description;
}

@end
