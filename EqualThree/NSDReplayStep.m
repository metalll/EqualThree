//
//  NSDReplayStep.m
//  EqualThree
//
//  Created by NSD on 11.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDReplayStep.h"

NSString * const kNSDReplayStepOperationType = @"kNSDReplayStepOperationType";
NSString * const kNSDOperatedItems = @"kNSDOperatedItems";

@implementation NSDReplayStep

- (void)encodeWithCoder:(NSCoder *)coder{
    
    [coder encodeObject:self.operatedItems forKey:kNSDOperatedItems];
    [coder encodeObject:@(self.operationType) forKey:kNSDReplayStepOperationType];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    
    if(self){
        
        self.operationType = [[aDecoder decodeObjectForKey:kNSDReplayStepOperationType] unsignedIntegerValue];
        self.operatedItems = [aDecoder decodeObjectForKey:kNSDOperatedItems];
    }
    
    return self;
}

@end
