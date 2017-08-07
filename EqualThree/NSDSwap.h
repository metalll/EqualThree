//
//  NSDSwap.h
//  EqualThree
//
//  Created by NSD on 28.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDIJStruct.h"


@interface NSDSwap : NSObject

@property NSDIJStruct *from;
@property NSDIJStruct *to;

- (instancetype) initSwapWithFrom:(NSDIJStruct *)from
                               to:(NSDIJStruct *)to;

- (NSArray *)toArray;

@end
