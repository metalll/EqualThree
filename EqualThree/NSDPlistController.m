//
//  NSDPlistController.m
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDPlistController.h"

@implementation NSDPlistController




+(void)loadPlistWithName:(NSString *)name andCompletion:(void (^)(NSArray *))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:name];
        if (![[NSFileManager defaultManager] fileExistsAtPath: plistPath])
        {
            
            
            //test lazy init
         NSArray * testArray = @[@[@"1",@"Vasya",@"20000"],@[@"2",@"Genya",@"500"],@[@"3",@"Genya",@"900000"]];
            
            
         [testArray writeToFile:plistPath atomically:YES];
       }
        
        NSArray * retValArray = [NSArray arrayWithContentsOfFile:plistPath];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion!=nil){
                completion(retValArray);
            }
        });
        
    });

 
}

+(void)savePlistWithName:(NSString *)name andStoredArray:(NSArray *)storedArray andCompletion:(void (^)(void))completion{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
        [storedArray writeToFile:plistPath atomically: YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion!=nil){
                completion();
            }
        });
        
    });

    
}

@end
