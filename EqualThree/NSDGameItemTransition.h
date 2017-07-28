//
//  NSDGameItemTransition.h
//  EqualThree
//
//  Created by NSD on 20.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDGameItemTransition.h"
#import "NSDGameItemType.h"
extern float const defaultAnimationDuration;

@interface NSDGameItemTransition : NSObject



@property float animationDuration;

@property NSDGameItemTransition * from;
@property NSDGameItemTransition * to;


#pragma mark - Init

- (instancetype) initWithFrom:(NSDGameItemTransition *) from
                           to:(NSDGameItemTransition *) to;


- (instancetype) initWithFrom:(NSDGameItemTransition *) from
                           to:(NSDGameItemTransition *) to
            animationDuration:(float) animationDuration;




@end
