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


- (instancetype) initSwapWithFromTransition: (NSDIJStruct*) from
                              toTransition : (NSDIJStruct*) to;

- (NSArray *) toArray;

@end
