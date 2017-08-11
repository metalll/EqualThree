//
//  NSDScoreRecord.m
//  EqualThree
//
//  Created by NSD on 10.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDScoreRecord.h"

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
    [encoder encodeObject:self.userScore forKey:@"userScore"];
    [encoder encodeObject:self.userName forKey:@"userName"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    if(self){
        
        self.userScore =[decoder decodeObjectForKey:@"userScore"];
        self.userName = [decoder decodeObjectForKey:@"userName"];
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
