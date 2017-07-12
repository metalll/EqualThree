//
//  NSMutableURLRequest+NSDBodySetter.h
//  EqualThree
//
//  Created by NSD on 12.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (NSDBodySetter)

-(void) setBodyData:(NSData *)data isJSONData:(BOOL) isJSONData;

@end
