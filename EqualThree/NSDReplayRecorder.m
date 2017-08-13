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

NSString * const lastSharedReplayFileName = @"TempReplay";
NSString * const sharedReplayPath = @"Replay";
NSUInteger const tempReplayID = 0;

@interface NSDReplayRecorder (){
    
    NSDReplay *_currentReplay;
    BOOL _isRestoredReplay;
    BOOL _isAddedHint;
    BOOL _isFirstRestoreTransition;
    
    dispatch_queue_t _operationQueue;
    NSArray * _hint;
}

- (void)saveChangesWithCompletion:(void(^)(void))completion;

- (void)subscribeToNotifications;
- (void)unsubscribeFromNotifications;

- (void)processUserDidHint;
- (void)processDidFindPermissibleStroke:(NSNotification *)notification;
- (void)processItemsDidDeleteNotification:(NSNotification *)notification;
- (void)processGotoAwaitStateNotification:(NSNotification *)notification;

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
    
    _operationQueue = dispatch_queue_create("com.nsd.game.replay.recorder.operation.queue", DISPATCH_QUEUE_SERIAL);
    [self subscribeToNotifications];
    _currentReplay = [NSDReplay new];
    _currentReplay.replayID = tempReplayID;
    _currentReplay.replayOperationsQueue = [[NSDQueue alloc] init];
    _hint = nil;
    _isRestoredReplay = NO;
    _isAddedHint = NO;
    _isFirstRestoreTransition = NO;
}

- (void)restoreRecorder{
    
    dispatch_group_t operationGroup = dispatch_group_create();
    
    dispatch_async(_operationQueue, ^{
        
        dispatch_group_enter(operationGroup);
        
        [NSDPlistController loadPlistWithName:lastSharedReplayFileName andCompletion:^(id lastSharedReplay)
         {
             [self subscribeToNotifications];
             _currentReplay = lastSharedReplay;
             dispatch_group_leave(operationGroup);
             
         }];
        
        dispatch_group_wait(operationGroup, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _isRestoredReplay = YES;
            _operationQueue = dispatch_queue_create("com.nsd.game.replay.recorder.operation.queue", DISPATCH_QUEUE_SERIAL);
            _isFirstRestoreTransition = YES;
            
            _isAddedHint = NO;
        });
    });
    
}

- (void)saveReplayWithID:(NSUInteger)ID{
    
    NSString * fileName = [sharedReplayPath stringByAppendingString:[@(ID) stringValue]];
    
    _currentReplay.replayID = ID;
    
    [NSDPlistController savePlistWithName:fileName andStoredObject:_currentReplay andCompletion:nil];
}


- (void)stopRecording{
    
    [self unsubscribeFromNotifications];
}


#pragma mark - Private

- (void)saveChangesWithCompletion:(void(^)(void))completion{
    
    [NSDPlistController savePlistWithName:lastSharedReplayFileName andStoredObject:_currentReplay andCompletion:completion];
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
    
    dispatch_group_t operationGroup = dispatch_group_create();
    
    dispatch_async(_operationQueue, ^{
        dispatch_group_enter(operationGroup);
        
        if(!_isAddedHint){
            
            NSDReplayStep *replayStep = [NSDReplayStep new];
            
            replayStep.operationType = Hint;
            replayStep.operatedItems = _hint;
            
            [_currentReplay.replayOperationsQueue enqueueWithObject:replayStep];
        }else{
            _isAddedHint = YES;
        }
        
        dispatch_group_leave(operationGroup);
        dispatch_group_wait(operationGroup, DISPATCH_TIME_FOREVER);
    });
}

- (void)processDidFindPermissibleStroke:(NSNotification *)notification{
    
    dispatch_group_t operationGroup = dispatch_group_create();
    
    dispatch_async(_operationQueue, ^{
        dispatch_group_enter(operationGroup);
        
        _isAddedHint = NO;
        
        NSArray *permissibleStroke = notification.userInfo[kNSDGameItems];
        _hint = permissibleStroke;
        dispatch_group_leave(operationGroup);
        dispatch_group_wait(operationGroup, DISPATCH_TIME_FOREVER);
    });
}

- (void)processItemsDidMoveNotification:(NSNotification *)notification{
    
    dispatch_group_t operationGroup = dispatch_group_create();
    
    dispatch_async(_operationQueue, ^{
        dispatch_group_enter(operationGroup);
        
        _isAddedHint = NO;
        
        if(_isFirstRestoreTransition){
            _isFirstRestoreTransition = NO;
            return;
        }
        
        NSArray *itemsTransitions = notification.userInfo[kNSDGameItemTransitions];
        
        NSDReplayStep *replayStep = [NSDReplayStep new];
        
        replayStep.operationType = Transition;
        replayStep.operatedItems = itemsTransitions;
        
        [_currentReplay.replayOperationsQueue enqueueWithObject:replayStep];
        dispatch_group_leave(operationGroup);
        dispatch_group_wait(operationGroup, DISPATCH_TIME_FOREVER);
    });
}

- (void)processItemsDidDeleteNotification:(NSNotification *)notification{
    
    dispatch_group_t operationGroup = dispatch_group_create();
    
    dispatch_async(_operationQueue, ^{
        dispatch_group_enter(operationGroup);
        
        _isAddedHint = NO;
        
        NSArray *itemsToDelete = notification.userInfo[kNSDGameItems];
        
        NSDReplayStep *replayStep = [NSDReplayStep new];
        
        replayStep.operationType = Delete;
        replayStep.operatedItems = itemsToDelete;
        
        [_currentReplay.replayOperationsQueue enqueueWithObject:replayStep];
        dispatch_group_leave(operationGroup);
        dispatch_group_wait(operationGroup, DISPATCH_TIME_FOREVER);
    });
}

- (void)processGotoAwaitStateNotification:(NSNotification *)notification{
    
    dispatch_group_t operationGroup = dispatch_group_create();
    
    dispatch_async(_operationQueue, ^{
        dispatch_group_enter(operationGroup);
        
        NSDReplayStep *replayStep = [NSDReplayStep new];
        
        replayStep.operationType = Pause;
        replayStep.operatedItems = nil;
        
        [_currentReplay.replayOperationsQueue enqueueWithObject:replayStep];
        
        [self saveChangesWithCompletion:^{
            dispatch_group_leave(operationGroup);
        }];
        
        dispatch_group_wait(operationGroup, DISPATCH_TIME_FOREVER);
    });
}

@end
