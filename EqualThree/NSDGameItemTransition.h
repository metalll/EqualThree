//
//  NSDGameItemTransition.h
//  EqualThree
//
//  Created by NSD on 20.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDIJStruct.h"
#import "NSDGameItemType.h"
#import "NSDSwap.h"
extern float const defaultAnimationDuration;

@interface NSDGameItemTransition : NSDSwap


@property NSInteger type;
@property float animationDuration;




#pragma mark - Init

- (instancetype) initWithFrom:(NSDIJStruct *) from
                           to:(NSDIJStruct *) to
                         type:(NSDGameItemType)type;

- (instancetype) initWithFrom:(NSDIJStruct *) from
                           to:(NSDIJStruct *) to
                         type:(NSDGameItemType)type
            animationDuration:(float) animationDuration;




@end
