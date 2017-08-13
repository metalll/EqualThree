//
//  NSDGameFieldViewController.h
//  EqualThree
//
//  Created by NSD on 14.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//




extern NSString * const NSDGameFieldDidEndDeletingNotification;
extern NSString * const kNSDDeletedItemsCost;


extern NSString * const NSDUserHintItems;

extern NSUInteger const NSDItemCost;
extern NSUInteger const NSDGameFieldWidth;
extern NSUInteger const NSDGameFieldHeight;

extern float const NSDDeleteAnimationDuration;

@interface NSDGameFieldViewController : UIViewController

@property BOOL isNewGame;
@property BOOL isReplay;
@property NSUInteger replayID;

@end
