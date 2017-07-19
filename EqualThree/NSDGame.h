//
//  NSDGame.h
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <Foundation/Foundation.h>



extern NSString * const NSDGameItemsDidMoveNotification;
extern NSString * const NSDGameItemsDidDeleteNotification;
extern NSString * const kNSDGameItems;





@interface NSDGame : NSObject




- (instancetype) initWithHorizontalItemsCount:(NSUInteger)n andVerticalItemsCount:(NSUInteger)m;

-(void) swapItemAtX0:(NSUInteger)x0
               andY0:(NSUInteger)y0
        withItemAtX1:(NSUInteger)x1
               andY1:(NSUInteger)y1;

@end
