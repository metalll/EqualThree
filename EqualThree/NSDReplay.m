//
//  NSDReplay.m
//  EqualThree
//
//  Created by NSD on 11.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDReplay.h"

NSString * kNSDReplayStepsQueue = @"kNSDReplayStepsQueue";
NSString * kNSDReplayID = @"kNSDReplayID";

@implementation NSDReplay

- (void)encodeWithCoder:(NSCoder *)coder{
    
    [coder encodeObject:self.replayOperationsQueue forKey:kNSDReplayStepsQueue];
    [coder encodeObject:@(self.replayID) forKey:kNSDReplayID];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    
    if(self){
        
        self.replayOperationsQueue = [aDecoder decodeObjectForKey:kNSDReplayStepsQueue];
        self.replayID = [[aDecoder decodeObjectForKey:kNSDReplayID] unsignedIntegerValue];
    }
    
    return self;
}

@end
