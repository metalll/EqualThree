//
//  NSDScoreRecord.h
//  EqualThree
//
//  Created by NSD on 10.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDScoreRecord : NSObject

@property NSString * UUID;

@property NSString * userName;
@property NSUInteger userScore;

#pragma mark - Init

-(instancetype)initWithUUID:(NSString *)UUID
                       name:(NSString *)name
                      score:(NSUInteger)score;

-(instancetype)initWithName:(NSString *)name
                      score:(NSUInteger)score;

@end
