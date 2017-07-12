//
//  NSURL+NSDURLDictionaryWrapper.m
//  EqualThree
//
//  Created by NSD on 12.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSURL+NSDURLDictionaryWrapper.h"

@implementation NSURL (NSDURLDictionaryWrapper)

- (NSDictionary *)dictionaryFromURL{
    NSString * queryString = [self query];
    NSArray * stringPairs = [queryString componentsSeparatedByString:@"&"];
    NSMutableDictionary * keyValuePairs = [NSMutableDictionary new];
    
    for(NSString * pair in stringPairs){
        NSArray * bits = [pair componentsSeparatedByString:@"="];
        if(bits.count>1){
            NSString * key = [(NSString *)[bits objectAtIndex:0] stringByRemovingPercentEncoding ] ;
            NSString * value = [(NSString *)[bits objectAtIndex:1] stringByRemovingPercentEncoding] ;
            [keyValuePairs setObject:value forKey:key];
        }
    }
    
    return keyValuePairs;
}

@end
