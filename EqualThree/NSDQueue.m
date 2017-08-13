//
//  NSDQueue.m
//  EqualThree
//
//  Created by NSD on 11.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDQueue.h"

NSString * const kNSDQueue = @"kNSDQueue";

@interface NSDQueue<__covariant ObjectType> (){
    
    NSMutableArray<ObjectType> *_queue;
}

@end

@implementation NSDQueue

- (instancetype)init{
    
    self = [super init];
    
    if(self){
        _queue = [NSMutableArray new];
    }
    
    return self;
}

- (NSUInteger)count{
    return _queue.count;
}

- (NSArray *)queue{
    
    return _queue;
}

- (id)peek{
    
    return [_queue firstObject];
}

- (id)lastEnqueueObject{
    
    return [_queue lastObject];
}

- (void)enqueueWithObject:(id)object{
    
    [_queue addObject:object];
}

- (id)dequeue{
    
    id dequeueObject = [_queue firstObject];
    
    [_queue removeObjectAtIndex:0];
    
    return dequeueObject;
}

#pragma mark Coding

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_queue forKey:kNSDQueue];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    
    if(self){
        
        _queue = [aDecoder decodeObjectForKey:kNSDQueue];
    }
    
    return self;
}

@end
