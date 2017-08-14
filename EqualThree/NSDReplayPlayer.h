//
//  NSDReplayPlayer.h
//  EqualThree
//
//  Created by NSD on 11.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

extern NSString * const NSDEndPlayReplay;

@interface NSDReplayPlayer : NSObject

@property NSString * UUID;

+ (instancetype)sharedInstance;

- (void)playReplayWithID:(NSUInteger)ID
                    UUID:(NSString *)UUID;

- (void)resumeReplay;

- (NSUInteger)currentReplayID;

- (void)pauseReplay;

- (void)stopReplay;

@end
