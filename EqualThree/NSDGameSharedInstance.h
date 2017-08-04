//
//  NSDGameSharedInstance.h
//  EqualThree
//
//  Created by NSD on 03.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const kField;
extern NSString * const kMoves;
extern NSString * const kScore;
extern NSString * const kSharedItemTypesCount;


@interface NSDGameSharedInstance : NSObject


@property NSMutableArray * field;
@property NSUInteger moves;
@property NSUInteger score;
@property NSUInteger sharedItemTypesCount;


-(NSDictionary *) dic;

+(instancetype) initWithDic:(NSDictionary *)dic;

@end
