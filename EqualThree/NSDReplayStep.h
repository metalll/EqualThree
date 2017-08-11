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
};


@interface NSDReplayStep : NSObject

@property NSDReplayStepOperationType operationType;
@property NSArray * operatedItems;

@end
