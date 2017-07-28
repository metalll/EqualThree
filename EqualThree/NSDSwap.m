//
//  NSDSwap.m
//  EqualThree
//
//  Created by NSD on 28.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDSwap.h"

@interface NSDSwap ()

@property NSDIJStruct * from;
@property NSDIJStruct * to;

@end



@implementation NSDSwap

-(instancetype)initSwapWithFromTransition:(NSDIJStruct *)from toTransition:(NSDIJStruct *)to{
    
    self = [super init];
    
    if(self){
    
        self.from = from;
        self.to = to;

    }

    return self;
}

-(NSArray *)toArray{

    return [NSArray arrayWithObjects:self.from,self.to, nil];
    
}


@end
