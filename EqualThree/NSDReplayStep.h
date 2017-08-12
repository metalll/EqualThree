//
//  NSDReplayStep.h
//  EqualThree
//
//  Created by NSD on 11.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//



typedef NS_ENUM(NSUInteger, NSDReplayStepOperationType) {
    Transition = 0,
    Delete,
    Hint,
    Pause
};

extern NSString * const kNSDReplayStepOperationType;
extern NSString * const kNSDOperatedItems;

@interface NSDReplayStep : NSObject<NSCoding>

@property NSDReplayStepOperationType operationType;
@property NSArray * operatedItems;

@end
