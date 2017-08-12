//
//  NSDReplay.h
//  EqualThree
//
//  Created by NSD on 11.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//


#import "NSDReplayStep.h"
#import "NSDQueue.h"

extern NSString * kNSDReplayStepsQueue;
extern NSString * kNSDReplayID;

@interface NSDReplay : NSObject<NSCoding>

@property NSUInteger replayID;

@property NSDQueue <NSDReplayStep *> *replayOperationsQueue;

@end
