//
//  NSDGame.m
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGame.h"

NSString * const NSDGameItemsDidMoveNotification = @"NSDItemDidMoveNotification";
NSString * const NSDGameItemsDidDeleteNotification = @"NSDItemDidRemoveNotification" ;
NSString * const kNSDGameItems = @"NSDItemsNotifaction" ;

@interface NSDGame ()

@property NSUInteger m;
@property NSUInteger n;

@property (nonatomic, strong) NSArray *gameField;


- (void) notifyAboutItemsMovement:(NSArray *) items;
- (void) notifyAboutItemsDeletion:(NSArray *) items;

- (void) applyUserAction;
- (void) revertUserAction;

- (void) checkMathingItems;
- (void) fillGaps;
- (void) deleteItems:(NSArray *) items;

@end

@implementation NSDGame

#pragma mark - Public Methods

-(instancetype)initWithHorizontalItemsCount:(NSUInteger)n andVerticalItemsCount:(NSUInteger)m{
    return nil;
}

-(void)swapItemAtX0:(NSUInteger)x0 andY0:(NSUInteger)y0 withItemAtX1:(NSUInteger)x1 andY1:(NSUInteger)y1{
    
    
    //NSArray * matchingItems = [self mathingItems];
//    if(matchingItems.count > 0){
    
    
  //      [self deleteItems:matchingItems];
        
    
   // }
    
   // else{
        
    
   // }
    
    
    

}


-(void)checkMathingItems{

    NSArray *result = [NSArray new];
//todo: do stuff
  //  return result;

    


}






-(void)applyUserAction{}




-(void) fillGaps {

    
    
}


-(void)deleteItems:(NSArray *)items{

}



#pragma mark - Notifications

-(void)notifyAboutItemsMovement:(NSArray *)items{
    NSNotification * notification = [NSNotification notificationWithName:NSDGameItemsDidMoveNotification object:nil
                                                                userInfo:@{ kNSDGameItems:items }];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}
-(void)notifyAboutItemsDeletion:(NSArray *)items{
    NSNotification * notification = [NSNotification notificationWithName:NSDGameItemsDidDeleteNotification object:nil
                                                                userInfo:@{ kNSDGameItems:items }];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
   
}
@end
