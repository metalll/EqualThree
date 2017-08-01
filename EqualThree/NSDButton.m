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
    CALayer * layer  = self.layer;
    layer.cornerRadius = 10.0;
    layer.masksToBounds = YES;
    
    
    self.titleLabel.font = [UIFont fontWithName:@"Noteworthy-Bold" size:20.0f];
    [self setTitleColor: [UIColor buttonTitleFontColor] forState:UIControlStateNormal];
    
    self.layer.borderWidth = 2.0;
    self.layer.borderColor = [[UIColor clearColor] CGColor];
    
    self.layer.shadowColor = [UIColor colorWithRed:(100.0f/255.0f) green:0.0 blue:0.0 alpha:1.0].CGColor;
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius = 1.0f;
    self.layer.shadowOffset = CGSizeMake(0, 3);
    
    
    
}

@end
