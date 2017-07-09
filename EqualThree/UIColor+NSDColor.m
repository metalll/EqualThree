//
//  UIColor+NSDColor.m
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "UIColor+NSDColor.h"

@implementation UIColor (NSDColor)

#pragma mark NSDToastColors

+(UIColor *)toastSimpleColor{
    return [UIColor colorWithRed:0.0/255.0 green:128.0/255.0 blue:218.0/255.0 alpha:1.0];
}

+(UIColor *)toastAcceptColor{
    return [UIColor greenColor];
}

+(UIColor *)toastErrorColor{
    return [UIColor redColor];
}

#pragma mark NSDNavColors

+(UIColor *) navigationBackgroundColor{
    return [UIColor darkGrayColor];
}
@end
