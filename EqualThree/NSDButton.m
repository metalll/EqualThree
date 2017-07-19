//
//  NSDButton.m
//  EqualThree
//
//  Created by NSD on 17.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDButton.h"
#import "UIColor+NSDColor.h"

@implementation NSDButton

-(void)drawRect:(CGRect)rect{
    //circle corners
    CALayer * layer  = self.layer;
    layer.cornerRadius = 10.0;
    layer.masksToBounds = YES;
    
    //background
    self.backgroundColor = [UIColor buttonBackgroundColor];
    [self.backgroundColor setFill];
    CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
    //titleFont
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f];
    [self setTitleColor: [UIColor buttonTitleFontColor] forState:UIControlStateNormal];
}

@end
