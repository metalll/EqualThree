//
//  NSDGameItemTransition.m
//  EqualThree
//
//  Created by NSD on 20.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGameItemTransition.h"

float const defaultAnimationDuration = 2.0f;

@implementation NSDGameItemTransition


#pragma mark - Init




- (instancetype) initWithFrom:(NSDGameItemTransition *) from
                           to:(NSDGameItemTransition *) to{
    

    return [self initWithFrom:from to:to animationDuration:defaultAnimationDuration];
}

- (instancetype) initWithFrom:(NSDGameItemTransition *) from
                           to:(NSDGameItemTransition *) to
            animationDuration:(float) animationDuration{


    self = [super init];
    
    if(self){
        
        self.from = from;
        self.to = to;
        self.animationDuration = animationDuration;
        
        
    }
    
    return self;


}

#pragma mark - Description

-(NSString *)description{

    NSString * description = [NSString stringWithFormat:@" from : %@ to: %@ animation duration : %f",self.from,self.to, self.animationDuration];
    
    return description;
}

@end
