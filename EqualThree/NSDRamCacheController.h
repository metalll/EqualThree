//
//  NSDRamCacheController.h
//  EqualThree
//
//  Created by NSD on 14.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDRamCacheController : NSObject

+(instancetype)sharedInstance;

- (void)objectForKey:(id)key andCompletion:(void(^)(NSData * object))completion;
- (void)setObject:(NSData *)object forKey:(id<NSCopying>)key ofLength:(NSUInteger)length;

@end
