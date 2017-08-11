//
//  NSDSwap.m
//  EqualThree
//
//  Created by NSD on 28.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDSwap.h"

@implementation NSDSwap

-(instancetype)initSwapWithFrom:(NSDIJStruct *)from
                             to:(NSDIJStruct *)to{
    
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

#pragma mark - Description

-(NSString *)description{
    
    NSString *description = [NSString stringWithFormat:@"from : %@ to: %@ ",self.from,self.to];
    
    return description;
}


@end
