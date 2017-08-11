//
//  NSDScoreRecord.h
//  EqualThree
//
//  Created by NSD on 10.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//


@interface NSDScoreRecord : NSObject<NSCoding>

@property NSString *userName;
@property NSNumber *userScore;
@property NSUInteger replayHash;
#pragma mark - Init

- (instancetype)initWithName:(NSString *)name
                       score:(NSNumber *)score;


@end
