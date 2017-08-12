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
#import "NSDGameEngine.h"
#import "NSDGameViewController.h"
NSString * const lastSharedReplayFileName = @"SharedReplay";
NSString * const sharedReplayPath = @"NSDEqualThreeReplays/";
NSUInteger const tempReplayID = 0;

@interface NSDReplayRecorder (){
    
    NSDReplay *_currentReplay;
    BOOL _isRestoredReplay;
    BOOL _isAddedHint;
    
    dispatch_queue_t _operationQueue;
    NSArray * _hint;
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
    _hint = nil;
    _isRestoredReplay = NO;
    _isAddedHint = NO;
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
            _operationQueue = dispatch_queue_create("com.nsd.game.replay.operation.queue", DISPATCH_QUEUE_SERIAL);
            

            _isAddedHint = NO;
        });
    });
    
}

- (void)saveChanges{
    
    [NSDPlistController savePlistWithName:lastSharedReplayFileName andStoredObject:_currentReplay andCompletion:nil];
}

- (void)dealloc{
    
    [self unsubscribeFromNotifications];
}

#pragma mark - Notifications

- (void)subscribeToNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processItemsDidMoveNotification:) name:NSDGameItemsDidMoveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processItemsDidDeleteNotification:) name:NSDGameItemsDidDeleteNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processGotoAwaitStateNotification:) name:NSDDidGoToAwaitState object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processDidFindPermissibleStroke:) name:NSDDidFindPermissibleStroke object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processUserDidHint) name:NSDUserDidTapHintButton object:nil];
    
}

- (void)unsubscribeFromNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)processUserDidHint{
    
    if(_isAddedHint){
        return;
    }
    
    _isAddedHint = YES;
    
    NSDReplayStep *replayStep = [NSDReplayStep new];
    
    replayStep.operationType = Hint;
    replayStep.operatedItems = _hint;
    
    [_currentReplay.replayOperationsQueue enqueueWithObject:replayStep];
}

- (void)processDidFindPermissibleStroke:(NSNotification *)notification{
    
    _isAddedHint = NO;
    
    NSArray *permissibleStroke = notification.userInfo[kNSDGameItems];
    _hint = permissibleStroke;
}

- (void)processItemsDidMoveNotification:(NSNotification *)notification{
    
    _isAddedHint = NO;
    
    NSArray *itemsTransitions = notification.userInfo[kNSDGameItemTransitions];
    
    NSDReplayStep *replayStep = [NSDReplayStep new];
    
    replayStep.operationType = Transition;
    replayStep.operatedItems = itemsTransitions;
    
    [_currentReplay.replayOperationsQueue enqueueWithObject:replayStep];
}

- (void)processItemsDidDeleteNotification:(NSNotification *)notification{
    
    _isAddedHint = NO;
    
    NSArray *itemsToDelete = notification.userInfo[kNSDGameItems];
    
    NSDReplayStep *replayStep = [NSDReplayStep new];
    
    replayStep.operationType = Delete;
    replayStep.operatedItems = itemsToDelete;
    
    [_currentReplay.replayOperationsQueue enqueueWithObject:replayStep];
}

- (void)processGotoAwaitStateNotification:(NSNotification *)notification{
    
    NSDReplayStep *replayStep = [NSDReplayStep new];
    
    replayStep.operationType = Pause;
    replayStep.operatedItems = nil;
    
    [_currentReplay.replayOperationsQueue enqueueWithObject:replayStep];
    
    [self saveChanges];
}

@end
