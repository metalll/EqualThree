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
#import "NSDGameViewController.h"

NSString * const NSDEndPlayReplay = @"NSDEndPlayReplay";

@interface NSDReplayPlayer (){
    
    NSDReplay *_currentReplay;
    NSOperationQueue *_replayQueue;
    dispatch_queue_t _underlingQueue;
    BOOL _canceled;
   
}

- (void)startReplay;

- (void)displayTransition:(NSArray *)transitionItems;
- (void)displayHint:(NSArray *)hintItems;
- (void)displayDelete:(NSArray *)deletedItems;
- (void)displayPause;

- (void)notifyAboutEndPlayingRecord;
- (void)notifyAboutUserDidTapHint:(NSArray *)hintItems;
- (void)notifyAboutItemsMovement:(NSArray *)itemTransitions;
- (void)notifyAboutItemsDeletion:(NSArray *)items;

@end

@implementation NSDReplayPlayer

static NSDReplayPlayer * instance;

#pragma mark - Singletone

+ (instancetype)sharedInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NSDReplayPlayer new];
        
        
        
    });
    
    return instance;
}

#pragma mark - Constructor

-(instancetype)init{
    
    self = [super init];
    
    if(self){
        _underlingQueue  = dispatch_queue_create("com.nsd.game.replay.player", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}


#pragma mark - Public

- (void)playReplayWithID:(NSUInteger)ID UUID:(NSString *)UUID{
    
    NSString * fileName = [sharedReplayPath stringByAppendingString:[@(ID) stringValue]];
    
    [NSDPlistController loadPlistWithName:fileName andCompletion:^(id replay) {
        _replayQueue = [[NSOperationQueue alloc] init];
        [_replayQueue setUnderlyingQueue:_underlingQueue];
        [_replayQueue setMaxConcurrentOperationCount:1];
        
        self.UUID = UUID;
        
        _currentReplay = replay;
        _canceled  = NO;
       
        
        [self startReplay];
    }];
}

- (void)pauseReplay{
    
    [_replayQueue setSuspended:YES];
}



- (void)resumeReplay{
    
    [_replayQueue setSuspended:NO];
}

- (void)stopReplay{
    
    [_replayQueue cancelAllOperations];
    
}

- (NSUInteger)currentReplayID{
    
 
    
    return _currentReplay.replayID;
}

#pragma mark - Private

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
                
                [self displayHint:_currentStep.operatedItems];
                
                break;
                
            case Pause:
                
                [self displayPause];
                
                break;
                
            default:
                break;
        }
    }
    
    [self notifyAboutEndPlayingRecord];
    
}


- (void)displayTransition:(NSArray *)transitionItems{
    
    NSBlockOperation * block = [NSBlockOperation blockOperationWithBlock: ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self notifyAboutItemsMovement:transitionItems];
            
        });
    }];
    
    [_replayQueue addOperations:@[block] waitUntilFinished:YES];
}

- (void)displayHint:(NSArray *)hintItems{
    
    
    NSBlockOperation * block = [NSBlockOperation blockOperationWithBlock: ^{
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self notifyAboutUserDidTapHint:hintItems];
            
            
        });
    }];
    
    [_replayQueue addOperations:@[block] waitUntilFinished:YES];
}

- (void)displayDelete:(NSArray *)deletedItems{
    
    NSBlockOperation * block = [NSBlockOperation blockOperationWithBlock: ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self notifyAboutItemsDeletion:deletedItems];
        });
        
    }];
    
    [_replayQueue addOperations:@[block] waitUntilFinished:YES];
}

- (void)displayPause{
    
    
    NSBlockOperation * block = [NSBlockOperation blockOperationWithBlock: ^{
        
    }];
    
    [_replayQueue addOperations:@[block] waitUntilFinished:YES];
}

#pragma mark - Notification

- (void)notifyAboutEndPlayingRecord {
    NSBlockOperation * block = [NSBlockOperation blockOperationWithBlock: ^{
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSNotification *notification = [NSNotification notificationWithName:NSDEndPlayReplay
                                                                         object:self];
            
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
        });
    }];
    
    [_replayQueue addOperations:@[block] waitUntilFinished:YES];
}

- (void)notifyAboutUserDidTapHint:(NSArray *)hintItems{
    
    NSNotification *notification = [NSNotification notificationWithName:NSDDidFindPermissibleStroke
                                                                 object:self
                                                               userInfo:@{kNSDGameItems : hintItems}];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

- (void)notifyAboutItemsMovement:(NSArray *)itemTransitions{
    
    NSNotification *notification = [NSNotification notificationWithName:NSDGameItemsDidMoveNotification
                                                                 object:self
                                                               userInfo:@{kNSDGameItemTransitions : itemTransitions}];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)notifyAboutItemsDeletion:(NSArray *)items{
    
    NSNotification *notification = [NSNotification notificationWithName:NSDGameItemsDidDeleteNotification
                                                                 object:self
                                                               userInfo:@{kNSDGameItems : items}];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
