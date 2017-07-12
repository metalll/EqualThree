//
//  NSDScoreRecord.m
//  EqualThree
//
//  Created by NSD on 10.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDScoreRecord.h"

@implementation NSDScoreRecord




-(instancetype)initWithName:(NSString *)name andScore:(NSUInteger)score{
    self = [super init];
    if (self) {
        self.UUID = [[NSUUID UUID] UUIDString];
        self.userName = name;
        self.userScore = score;
    }
    return self;
    
}

-(instancetype)initWithUUID:(NSString *)UUID andName:(NSString *)name andScore:(NSUInteger)score{
    self = [super init];
    if (self) {
        self.UUID = [[NSUUID UUID] UUIDString];
        self.userName = name;
        self.userScore = score;
    }
    return self;
    
}





@end
