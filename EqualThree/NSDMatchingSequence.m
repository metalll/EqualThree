//
//  NSDMatchingSequence.m
//  EqualThree
//
//  Created by NSD on 25.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDMatchingSequence.h"

@implementation NSDMatchingSequence


- (NSString*)description {
    return [NSString stringWithFormat:@"(%ld, %ld) -> (%ld, %ld)", (long)self.i0, (long)self.j0, (long)self.i1, (long)self.j1];
}

@end
