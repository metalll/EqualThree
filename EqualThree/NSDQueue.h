//
//  NSDQueue.h
//  EqualThree
//
//  Created by NSD on 11.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//


@interface NSDQueue<__covariant ObjectType> : NSObject

- (NSArray<ObjectType> *)queue;

- (void)enqueueWithObject:(ObjectType)object;
- (ObjectType)lastEnqueueObject;
- (ObjectType)dequeue;
- (ObjectType)peek;

@end
