//
//  NSDGameSharedInstance.h
//  EqualThree
//
//  Created by NSD on 03.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDGameSharedInstance : NSObject


@property NSMutableArray * field;
@property NSUInteger moves;
@property NSUInteger score;
@property NSUInteger itemTypesCount;

@end
