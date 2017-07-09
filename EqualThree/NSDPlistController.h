//
//  NSDPlistController.h
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDPlistController : NSObject


+(void) loadPlistWithName : (NSString *) name
                 andCompletion : (void (^)(NSArray *)) completion;

+(void) savePlistWithName : (NSString *)name
           andStoredArray : (NSArray *) storedArray
            andCompletion : (void (^)(void)) completion;

@end
