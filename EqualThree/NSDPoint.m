//
//  NSDPoint.m
//  EqualThree
//
//  Created by NSD on 10.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDPoint.h"

@implementation NSDPoint

- (instancetype)initWithX: (int) x
                     andY: (int) y
{
    self = [super init];
    if (self) {
        
        self.x=x;
        self.y=y;
        
    }
    return self;
}


@end
