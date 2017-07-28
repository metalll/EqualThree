//
//  NSDSwap.m
//  EqualThree
//
//  Created by NSD on 28.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDSwap.h"

@interface NSDSwap ()

@property NSDGameItemTransition * from;
@property NSDGameItemTransition * to;

@end



@implementation NSDSwap



-(instancetype) initSwapWithFromTransition:(NSDGameItemTransition *)from
                              toTransition:(NSDGameItemTransition *)to{

    
    self = [super init];
    
    if(self){
    
        self.from = from;
        self.to = to;
        
    }
    
    
    return self;
}

- (NSArray *)toArray {
    NSArray * result = nil;
    
    result = [[NSArray alloc] initWithObjects:(NSDGameItemTransition *)self.from,(NSDGameItemTransition*)self.to, nil];
    
    return result;
    
}





@end
