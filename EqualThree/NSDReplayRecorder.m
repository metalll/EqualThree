//
//  NSDReplayRecorder.m
//  EqualThree
//
//  Created by NSD on 11.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDReplayRecorder.h"
#import "NSDReplay.h"
#import "NSDPlistController.h"

NSString * const lastSharedReplayFileName = @"SharedReplay";
NSString * const sharedReplayPath = @"NSDEqualThreeReplays/";
NSUInteger const tempReplayID = 0;

@interface NSDReplayRecorder (){
    
    NSDReplay *_currentReplay;
    BOOL _isRestoredReplay;
    dispatch_queue_t _operationQueue;
}

- (void)saveChanges;

- (void)subscribeToNotifications;
- (void)unsubscribeFromNotifications;

@end

@implementation NSDReplayRecorder

#pragma mark - Singletone

static NSDReplayRecorder *instance;

+ (instancetype)sharedInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NSDReplayRecorder new];
    });
    
    return instance;
}

#pragma mark - Public

- (void)configureRecorder{
    
    _operationQueue = dispatch_queue_create("com.nsd.game.replay.operation.queue", DISPATCH_QUEUE_SERIAL);
    
    _currentReplay = [NSDReplay new];
    _currentReplay.replayID = tempReplayID;
    _currentReplay.replayOperationsQueue = [[NSDQueue alloc] init];
    _isRestoredReplay = NO;
}

- (void)restoreRecorder{
    
    dispatch_group_t operationGroup = dispatch_group_create();
    
    dispatch_async(_operationQueue, ^{
        
        dispatch_group_enter(operationGroup);
        
        [NSDPlistController loadPlistWithName:lastSharedReplayFileName andCompletion:^(id lastSharedReplay)
         {
             _currentReplay = lastSharedReplay;
             dispatch_group_leave(operationGroup);
             
         }];
        
        dispatch_group_wait(operationGroup, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _isRestoredReplay = YES;
        });
    });
    
}

- (void)saveChanges{
    
}

- (void)dealloc{
    
    [self unsubscribeFromNotifications];
}

#pragma mark - Notifications

- (void)subscribeToNotifications{
    
}

- (void)unsubscribeFromNotifications{
    
}

- (void)processDid{
    
}

@end
