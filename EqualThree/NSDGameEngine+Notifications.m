//
//  NSDGameEngine+Notifications.m
//  EqualThree
//
//  Created by NSD on 10.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGameEngine+Notifications.h"

@implementation NSDGameEngine (Notifications)


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


- (void)notifyAboutDidDetectGameOver{
    
    NSNotification *notification = [NSNotification notificationWithName:NSDDidDetectGameOver
                                                                 object:self
                                                               userInfo:@{
                                                                          kNSDUserScore : @(self.userScore),
                                                                          kNSDMovesCount: @(self.movesCount)
                                                                          }];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)notifyAboutDidFindPermissibleStroke:(NSArray *)gameItems{
    
    NSNotification *notification = [NSNotification notificationWithName:NSDDidFindPermissibleStroke
                                                                 object:self
                                                               userInfo:@{kNSDGameItems : gameItems}];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)notifyAboutDidUpdateUserScore{
    
    NSNotification *notification = [NSNotification notificationWithName:NSDDidUpdateUserScore
                                                                 object:self
                                                               userInfo:@{
                                                                          kNSDUserScore : @(self.userScore)
                                                                          }];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)notifyAboutDidUpdateMoviesCount{
    
    NSNotification *notification = [NSNotification notificationWithName:NSDDidUpdateMovesCount
                                                                 object:self
                                                               userInfo:@{
                                                                          kNSDMovesCount : @(self.movesCount)
                                                                          }];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)notifyAboutDidGoToAwaitState{
    
    NSNotification *notification = [NSNotification notificationWithName:NSDDidGoToAwaitState
                                                                 object:self
                                                               userInfo:@{
                                                                          kNSDGameItems : [self.gameField copy],
                                                                          kNSDUserScore : @(self.userScore),
                                                                          kNSDMovesCount : @(self.movesCount),
                                                                          kNSDGameItemsTypeCount : @(self.itemTypesCount)
                                                                          }];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)notifyAboutDidUpdateSharedUserScore{
    
    NSNotification *notification = [NSNotification notificationWithName:NSDDidUpdadeSharedUserScore
                                                                 object:self
                                                               userInfo:@{
                                                                          kNSDUserScore : @(self.userScore)
                                                                          }];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
