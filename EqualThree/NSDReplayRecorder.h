//
//  NSDReplayRecorder.h
//  EqualThree
//
//  Created by NSD on 11.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//



extern NSString * const lastSharedReplayFileName;
extern NSString * const sharedReplayPath;
extern NSUInteger const tempReplayID;

@interface NSDReplayRecorder : NSObject

+ (instancetype)sharedInstance;

- (void)configureRecorder;

- (void)restoreRecorder;

- (void)stopRecording;

- (void)saveReplayWithID:(NSUInteger)ID;

@end
