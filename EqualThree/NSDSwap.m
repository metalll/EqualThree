//
//  NSDSwap.m
//  EqualThree
//
//  Created by NSD on 28.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDSwap.h"

NSString * const kNSDFrom = @"kNSDFrom";
NSString * const kNSDTo = @"kNSDTo";

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

#pragma mark - Coding

- (void)encodeWithCoder:(NSCoder *)aCoderP{
    
    [aCoderP encodeObject:self.from forKey:kNSDFrom];
    [aCoderP encodeObject:self.to forKey:kNSDTo];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    
    if(self){
        
        self.from = [aDecoder decodeObjectForKey:kNSDFrom];
        self.to = [aDecoder decodeObjectForKey:kNSDTo];
    }
    
    return self;
}

@end
