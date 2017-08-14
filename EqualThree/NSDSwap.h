//
//  NSDSwap.h
//  EqualThree
//
//  Created by NSD on 28.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDIJStruct.h"

extern NSString * const kNSDFrom;
extern NSString * const kNSDTo;

@interface NSDSwap : NSObject<NSCoding>

@property NSDIJStruct *from;
@property NSDIJStruct *to;

- (instancetype) initSwapWithFrom:(NSDIJStruct *)from
                               to:(NSDIJStruct *)to;

- (NSArray *)toArray;

@end
