//
//  NSDRamCacheController.m
//  EqualThree
//
//  Created by NSD on 14.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDRamCacheController.h"
#define DOCUMENTS [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
@implementation NSDRamCacheController{
    NSMutableDictionary *cacheDic;
    NSMutableArray *array;
    NSUInteger size;
}


+(instancetype)sharedInstance{
    static NSDRamCacheController * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        instance = [[NSDRamCacheController alloc] init];
    });
    
    
    return instance;
}

- (NSMutableDictionary *)dic {
    return self->cacheDic;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        cacheDic = [NSMutableDictionary dictionary];
        array = [NSMutableArray array];
    }
    return self;
}


- (void)objectForKey:(id)key andCompletion:(void (^)(NSData * object))completion {
    NSData * retVal =[[self dic] objectForKey:key];
    if(retVal && completion){
        completion(retVal);
        return;
    }
    
    
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:key] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
   
        if(!error && data){
            dispatch_async(dispatch_get_main_queue(), ^{
                
              
                [self setObject:data forKey:key ofLength:data.length];
                completion(retVal);
                return;
            });
        }
        
    }]resume];
    
}



- (void)setObject:(NSData *)object forKey:(id<NSCopying>)key ofLength:(NSUInteger)length {
    
    @synchronized(self) {
        
        if (self->size >= 1000 * 1000 * 25) {
            
            
            
            NSUInteger minusSize = 0;
            NSUInteger expectedHalfSize = self->size / 2;
            NSUInteger i = 0;
            for (; i < [self->array count]; i++) {
                id dic = self->array[i];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    minusSize += [dic[@"length"] unsignedIntegerValue];
                    
                    
                    
                    [self->cacheDic removeObjectForKey:dic[@"key"]];
                    if (minusSize >= expectedHalfSize) {
                        break;
                    }
                }
            }
            
            [self->array removeObjectsInRange:NSMakeRange(0, i + 1)];
            
            self->size -= minusSize;
        }
        
        [self->cacheDic setObject:object forKey:key];
        [self->array addObject:@{@"key": key, @"length": @(length)}];
        self->size += length;
    }
}



@end
