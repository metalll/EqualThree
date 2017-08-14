//
//  NSDQueue.h
//  EqualThree
//
//  Created by NSD on 11.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

extern NSString * const kNSDQueue;

@interface NSDQueue<__covariant ObjectType> : NSObject<NSCoding>

- (NSArray<ObjectType> *)queue;

- (void)enqueueWithObject:(ObjectType)object;
- (ObjectType)lastEnqueueObject;
- (ObjectType)dequeue;
- (ObjectType)peek;
- (NSUInteger)count;

@end
