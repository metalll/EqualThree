//
//  UIColor+NSDColor.m
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "UIColor+NSDColor.h"

@implementation UIColor (NSDColor)


+ (instancetype)alertBackroundColor{
    
    return [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
}

#pragma mark NSDNavColors

+ (instancetype)navigationBackgroundColor{
    
    return [UIColor colorWithRed:204.0/255.0 green:102.0/255.0 blue:255.0/255.0 alpha:1.0];
}

+ (instancetype)navigationForegroundColor{
   
    return [UIColor whiteColor];
}

#pragma mark NSDButtonColors

+ (instancetype)buttonBackgroundColor{
    
    return [UIColor redColor];
}

+ (instancetype)buttonTitleFontColor{

    return [UIColor whiteColor];
}

#pragma mark NSDTableViewHighscoresColors

+ (instancetype)goldColor{
    
    return [UIColor colorWithRed:255.0/255.0 green:215.0/255.0 blue:0.0/255.0 alpha:1.0];
}

+ (instancetype)silverColor{
    
    return [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
}

+ (instancetype)bronzeColor{
    
    return [UIColor colorWithRed:205.0/255.0 green:127.0/255.0 blue:50.0/255.0 alpha:1.0];
}

@end
