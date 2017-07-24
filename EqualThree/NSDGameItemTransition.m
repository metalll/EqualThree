//
//  NSDGameItemTransition.m
//  EqualThree
//
//  Created by NSD on 20.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGameItemTransition.h"

@implementation NSDGameItemTransition


#pragma mark - constructor

- (instancetype)initWithX0:(NSUInteger)x0 andY0:(NSUInteger)y0 andX1:(NSUInteger)x1 andY1:(NSUInteger)y1 andType:(NSUInteger)type
{
    self = [super init];
    if (self) {
        self.x0 = x0;
        self.x1 = x1;
        self.y1 = y1;
        self.y0 = y0;
        self.type = type;
    }
    return self;
}


@end
