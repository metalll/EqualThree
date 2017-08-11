//
//  NSDGameEngine+Notifications.h
//  EqualThree
//
//  Created by NSD on 10.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGameEngine.h"

@interface NSDGameEngine (Notifications)

- (void)notifyAboutItemsMovement:(NSArray*)items;
- (void)notifyAboutItemsDeletion:(NSArray*)items;
- (void)notifyAboutDidFindPermissibleStroke:(NSArray *) gameItems;
- (void)notifyAboutDidDetectGameOver;
- (void)notifyAboutDidGoToAwaitState;
- (void)notifyAboutDidUpdateMoviesCount;
- (void)notifyAboutDidUpdateUserScore;
- (void)notifyAboutDidUpdateSharedUserScore;

@end
