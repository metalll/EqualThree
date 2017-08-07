//
//  NSDPlistController.m
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDPlistController.h"

@implementation NSDPlistController

+ (void)loadPlistWithName:(NSString *)name
            andCompletion:(void (^)(id))completion{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:[name stringByAppendingString:@".plist"]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(completion) completion(nil);
            });
            return ;
        }
        
        
        id retValObject =  [NSKeyedUnarchiver unarchiveObjectWithFile:plistPath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion){
                completion(retValObject);
            }
        });
        
    });
    
    
}

+ (void)savePlistWithName:(NSString *)name
          andStoredObject:(id)storedObject
            andCompletion:(void (^)(void))completion{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:[name stringByAppendingString:@".plist"]];
        
#ifdef DEBUG
        NSLog(@"stored fileName %@",plistPath);
#endif
        
        [NSKeyedArchiver archiveRootObject:storedObject toFile:plistPath ];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion){
                completion();
            }
        });
        
    });
}

+ (void) removeFileWithName:(NSString *)name{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:[name stringByAppendingString: @".plist"]];
        NSError *error;
        
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    });
}


@end
