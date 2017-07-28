//
//  NSDGameTransitionItem.m
//  EqualThree
//
//  Created by NSD on 29.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGameTransitionElement.h"

@implementation NSDGameTransitionElement




- (instancetype)initWithI:(NSUInteger) i andJ: (NSUInteger) j andType:(NSDGameItemType) type;
{
    self = [super initWithI:i andJ:j];
    if (self) {
        self.type = type;
    }
    return self;
}

@end
