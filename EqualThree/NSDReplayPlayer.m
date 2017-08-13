//
//  NSDReplayPlayer.m
//  EqualThree
//
//  Created by NSD on 11.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDReplayPlayer.h"
#import "NSDReplay.h"
#import "NSDReplayRecorder.h"
#import "NSDPlistController.h"
#import "NSDGameEngine.h"

@implementation NSDReplayPlayer{
    NSDReplay *_currentReplay;
    dispatch_queue_t _replayQueue;
}

static NSDReplayPlayer * instance;

+ (instancetype)sharedInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NSDReplayPlayer new];
    });
    
    return instance;
}


- (void)playReplayWithID:(NSUInteger)ID{
    
    NSString * fileName = [sharedReplayPath stringByAppendingString:[@(ID) stringValue]];
    
    [NSDPlistController loadPlistWithName:fileName andCompletion:^(id replay) {
        
        _currentReplay = replay;
        
        _replayQueue = dispatch_queue_create("dcdsddfsdfa", DISPATCH_QUEUE_SERIAL);
        
        [self startReplay];
        
    }];
}

- (void)startReplay{
    
    while (_currentReplay.replayOperationsQueue.count > 0) {
        
        NSDReplayStep * _currentStep = [_currentReplay.replayOperationsQueue dequeue];
        
        switch (_currentStep.operationType) {
                
            case Transition:
                
                [self displayTransition:_currentStep.operatedItems];
                
                break;
                
            case Delete:
                
                [self displayDelete:_currentStep.operatedItems];
                
                
                break;
                
            case Hint:
                
                break;
                
            case Pause:
                
                break;
                
            default:
                break;
        }
    }
}

- (void)pauseReplay{
    
    dispatch_suspend(_replayQueue);
}

- (void)resumeReplay{
    
    dispatch_resume(_replayQueue);
}

- (void)displayTransition:(NSArray *)transitionItems{
    
    dispatch_group_t operationGroup = dispatch_group_create();
    
    dispatch_async(_replayQueue, ^{
        dispatch_group_enter(operationGroup);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self notifyAboutItemsMovement:transitionItems];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_group_leave(operationGroup);
        });
        
        dispatch_group_wait(operationGroup, DISPATCH_TIME_FOREVER);
    });
}

- (void)displayHint:(NSArray *)hintItems{
    
    dispatch_group_t operationGroup = dispatch_group_create();
    
    dispatch_async(_replayQueue, ^{
        dispatch_group_enter(operationGroup);
        
        
        
        dispatch_group_wait(operationGroup, DISPATCH_TIME_FOREVER);
    });
}

- (void)displayDelete:(NSArray *)deletedItems{
    
    dispatch_group_t operationGroup = dispatch_group_create();
    
    dispatch_async(_replayQueue, ^{
        dispatch_group_enter(operationGroup);
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self notifyAboutItemsDeletion:deletedItems];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_group_leave(operationGroup);
        });
        
        
        
        
        
        dispatch_group_wait(operationGroup, DISPATCH_TIME_FOREVER);
    });
}

- (void)displayPause{
    
    dispatch_group_t operationGroup = dispatch_group_create();
    
    dispatch_async(_replayQueue, ^{
        
        dispatch_group_enter(operationGroup);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            dispatch_group_leave(operationGroup);
        });
        dispatch_group_wait(operationGroup, DISPATCH_TIME_FOREVER);
    });
}

- (void)notifyAboutItemsMovement:(NSArray *)itemTransitions{
    
    NSNotification *notification = [NSNotification notificationWithName:NSDGameItemsDidMoveNotification
                                                                 object:nil
                                                               userInfo:@{kNSDGameItemTransitions : itemTransitions}];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)notifyAboutItemsDeletion:(NSArray *)items{
    
    NSNotification *notification = [NSNotification notificationWithName:NSDGameItemsDidDeleteNotification
                                                                 object:nil
                                                               userInfo:@{kNSDGameItems : items}];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}


@end
