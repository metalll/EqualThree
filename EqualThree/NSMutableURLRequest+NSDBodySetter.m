//
//  NSMutableURLRequest+NSDBodySetter.m
//  EqualThree
//
//  Created by NSD on 12.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSMutableURLRequest+NSDBodySetter.h"

@implementation NSMutableURLRequest (NSDBodySetter)

-(void)setBodyData:(NSData *)data isJSONData:(BOOL)isJSONData{
    
    self.HTTPBody = data;
    
    if(isJSONData) return;
    
    [self setValue: [NSString stringWithFormat:@"%lu",(unsigned long)data.length] forHTTPHeaderField:@"Content-Length"];
    [self setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"application/x-www-form-urlencoded; charset=utf-8"];
}

@end
