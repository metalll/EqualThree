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

-(instancetype)initWithName:(NSString *)name
                      score:(NSUInteger)score {
    
    return [self initWithUUID: [[NSUUID UUID] UUIDString] name:name score:score];

}

-(instancetype)initWithUUID:(NSString *)UUID
                       name:(NSString *)name
                      score:(NSUInteger)score{
  
    self = [super init];
    
    if (self) {
        self.UUID = UUID;
        self.userName = name;
        self.userScore = score;
    }
    
    return self;
    
}





@end
