//
//  NSDPlistController.m
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDPlistController.h"

@implementation NSDPlistController


+(void) removeFileWithName:(NSString *)name{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:[name stringByAppendingString: @".plist"]];
        
        NSError *error;
        if(![[NSFileManager defaultManager] removeItemAtPath:path error:&error])
        {
            //TODO: Handle/Log error
        }
        
    });
    
}

+(void)loadPlistWithName:(NSString *)name
    andLoadedObjectClass:(Class) loadedObjectClass
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
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:[name stringByAppendingString:@".plist"]];
        
        NSLog(@"stored fileName %@",plistPath);
        
        NSError * error;
        
        
        [storedObject writeToFile:plistPath atomically: YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion){
                completion();
            }
        });
        
    });
    
    
}

@end
