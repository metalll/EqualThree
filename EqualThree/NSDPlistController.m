//
//  NSDPlistController.m
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDPlistController.h"

@implementation NSDPlistController




+(void)loadPlistWithName:(NSString *)name
    andLoadedObjectClass:(Class) loadedObjectClass
           andCompletion:(void (^)(id))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:name];
        if (![[NSFileManager defaultManager] fileExistsAtPath: plistPath])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(completion) completion(nil);
            });
            return ;
        }
        
        id retValObject = nil;
        
        if(loadedObjectClass == [NSArray class]){
            retValObject = [NSArray arrayWithContentsOfFile:plistPath];
        }
        
        if(loadedObjectClass == [NSMutableArray class]){
            retValObject = [NSMutableArray arrayWithContentsOfFile:plistPath];
        }
        
        if(loadedObjectClass == [NSDictionary class]){
            retValObject = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        }
        
        if(loadedObjectClass == [NSMutableDictionary class]){
            retValObject = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
        }
        
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion){
                completion(retValObject);
            }
        });
        
    });
    
    
}

+(void)savePlistWithName:(NSString *)name andStoredObject:(id)storedObject andCompletion:(void (^)(void))completion{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if(![storedObject respondsToSelector:@selector(writeToFile:atomically:)]){
            
            
            return ;
        }
        
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:name];
        if (![[NSFileManager defaultManager] fileExistsAtPath: plistPath])
        {
            NSArray * tempNameArr = [name componentsSeparatedByString:@"."];
            
            NSString *bundle = [[NSBundle mainBundle] pathForResource:tempNameArr[0] ofType:tempNameArr[1]];
            [[NSFileManager defaultManager] copyItemAtPath:bundle toPath:plistPath error:&error];
        }
        
        [storedObject writeToFile:plistPath atomically: YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion){
                completion();
            }
        });
        
    });
    
    
}

@end
