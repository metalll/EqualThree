//
//  NSDGameItemTransition.h
//  EqualThree
//
//  Created by NSD on 20.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDGameItemTransition : NSObject

@property NSInteger x0;
@property NSInteger y0;
@property NSInteger x1;
@property NSInteger y1;
@property NSInteger type;


#pragma mark - costructor

- (instancetype)initWithX0:(NSUInteger)x0 andY0:(NSUInteger)y0 andX1:(NSUInteger)x1 andY1:(NSUInteger)y1 andType:(NSUInteger)type;


@end
