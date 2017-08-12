//
//  NSDScoreRecord.m
//  EqualThree
//
//  Created by NSD on 10.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDScoreRecord.h"

NSString * const kUserName = @"kUserName";
NSString * const kUserScore = @"kUserScore";
NSString * const kUserReplayID = @"kUserReplayID";

@implementation NSDScoreRecord

#pragma mark - Init

- (instancetype)initWithName:(NSString *)name
                       score:(NSNumber *)score {
    
    self = [super init];
    
    if (self) {
        self.userName = name;
        self.userScore = score;
        
    }
    
    return self;
}


#pragma mark - Coding

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.userScore forKey:kUserScore];
    [encoder encodeObject:self.userName forKey:kUserName];
    [encoder encodeObject:@(self.replayID) forKey:kUserReplayID];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    if(self){
        
        self.userScore = [decoder decodeObjectForKey:kUserScore];
        self.userName = [decoder decodeObjectForKey:kUserName];
        self.replayID = [[decoder decodeObjectForKey:kUserReplayID] unsignedIntegerValue];
    }
    
    return self;
}

- (BOOL)isEqual:(id)other{
    
    NSDScoreRecord * comparedRecord = nil;
    
    if([other isKindOfClass:[self class]]){
        
        comparedRecord = (NSDScoreRecord *)other;
    }
    
    if (comparedRecord==nil) {
        return NO;
    }
    
    return [self.userName isEqual:comparedRecord.userName] && [self.userScore isEqual:comparedRecord.userScore];
    
}

- (NSUInteger)hash{
    
    return [self.userName hash]*[self.userScore hash];
}

@end
