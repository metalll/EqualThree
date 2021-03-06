//
//  NSDGameSharedInstance.m
//  EqualThree
//
//  Created by NSD on 03.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGameSharedInstance.h"

NSString * const kField = @"kField";
NSString * const kMoves = @"kMoves";
NSString * const kScore = @"kScore";
NSString * const kSharedItemTypesCount = @"kSharedItemTypesCount";


@implementation NSDGameSharedInstance

+ (instancetype)initWithDic:(NSDictionary *)dic{
    
    if(dic == nil) return nil;
    
    NSDGameSharedInstance * new = [super new];
    
    if (new) {
        
        new.field = dic[kField];
        new.moves = [dic[kMoves] unsignedIntegerValue];
        new.score = [dic[kScore] unsignedIntegerValue];
        new.sharedItemTypesCount = [dic[kSharedItemTypesCount] unsignedIntegerValue];
    }
    
    return new;
}

- (NSDictionary *)dic{
    
    return @{
             kField : self.field,
             kMoves : @(self.moves),
             kScore : @(self.score),
             kSharedItemTypesCount : @(self.sharedItemTypesCount)
             
             };
}

@end
