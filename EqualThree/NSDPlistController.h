//
//  NSDPlistController.h
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDPlistController : NSObject


+ (void)loadPlistWithName:(NSString *)name
            andCompletion:(void (^)(id))completion;

+ (void) savePlistWithName : (NSString *)name
           andStoredObject : (id) storedObject
             andCompletion : (void (^)(void)) completion;

+ (void) removeFileWithName:(NSString *)name;

@end
