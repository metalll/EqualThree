//
//  NSDGameItemView.h
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//


@interface NSDGameItemView : UIImageView

@property (nonatomic) NSUInteger type;

- (void)animateDestroyWithDuration:(float)duration
                        completion:(void (^)(void))completion;

@end
