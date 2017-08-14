//
//  NSDReplayPlayer.h
//  EqualThree
//
//  Created by NSD on 11.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

extern NSString * const NSDEndPlayReplay;

@interface NSDReplayPlayer : NSObject

+ (instancetype)sharedInstance;

- (void)playReplayWithID:(NSUInteger)ID;

- (void)resumeReplay;

- (void)pauseReplay;

- (void)stopReplay;

@end
