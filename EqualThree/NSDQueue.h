//
//  NSDQueue.h
//  EqualThree
//
//  Created by NSD on 11.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//


@interface NSDQueue : NSObject

- (NSArray *)queue;

- (void)enqueueWithObject:(id)object;
- (id)lastEnqueueObject;
- (id)dequeue;
- (id)peek;

@end
