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

    CALayer * layer  = self.layer;
    
    layer.cornerRadius = 5.0;
    layer.masksToBounds = YES;
    

}


@end
