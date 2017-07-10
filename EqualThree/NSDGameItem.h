//
//  NSDGameItem.h
//  EqualThree
//
//  Created by NSD on 10.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDGameItemType.h"
#import "NSDPoint.h"



@interface NSDGameItem : NSObject






@property (nonatomic) BOOL bonus;
@property(nonatomic) NSDGameItemType itemType;
@property NSDPoint * point;


@end
