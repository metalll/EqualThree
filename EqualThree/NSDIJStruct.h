//
//  NSDIJStruct.h
//  EqualThree
//
//  Created by NSD on 24.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//



extern NSString * const kNSDI;
extern NSString * const kNSDJ;

@interface NSDIJStruct : NSObject<NSCoding>

@property NSInteger i;
@property NSInteger j;

- (instancetype)initWithI:(NSUInteger)i andJ:(NSUInteger)j;

@end
