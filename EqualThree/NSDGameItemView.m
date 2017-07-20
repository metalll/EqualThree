//
//  NSDGameItemView.m
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGameItemView.h"

@implementation NSDGameItemView


-(void)drawRect:(CGRect)rect{

    
    
    
    self.bounds = CGRectInset(rect, 2.0f, 2.0f);
    CALayer * layer  = self.layer;
    
    layer.cornerRadius = 5.0;
    layer.masksToBounds = YES;
    
    
    
    
    
    
    
    
    

}


- (UIColor *) colorForType:(NSUInteger)type{

    UIColor * result = nil;
    
    
    switch (type) {
   
        case 0:
            result = [UIColor lightGrayColor];
            
        case 1:
           result = [UIColor redColor];
            break;
        case 2:
         result =   [UIColor greenColor];
            break;
        case 3:
          result=   [UIColor orangeColor];
            break;
        case 4:
         result =   [UIColor blueColor];
            break;
        case 5:
        result=      [UIColor cyanColor];
            break;
        case 6:
          result =  [UIColor yellowColor];
            break;
        case 7:
            result = [UIColor magentaColor];
            break;
          
            
            
           }
    
    return result;

}



-(void)setType:(NSUInteger)type{
    
    
    if(_type!=type){
        _type = type;
    }
    
    
    
    [self setBackgroundColor:[self colorForType:_type]];
    
    
    

        
    
    
}

@end
