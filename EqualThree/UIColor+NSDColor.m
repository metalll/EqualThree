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

+(instancetype)toastSimpleColor{
    return [UIColor colorWithRed:0.0/255.0 green:128.0/255.0 blue:218.0/255.0 alpha:1.0];
}

+(instancetype)toastAcceptColor{
    return [UIColor greenColor];
}

+(instancetype)toastErrorColor{
    return [UIColor redColor];
}

#pragma mark NSDNavColors

+(instancetype) navigationBackgroundColor{
    return [UIColor darkGrayColor];
}

#pragma mark NSDButtonColors

+(instancetype) buttonBackgroundColor{
    return [UIColor redColor];
}

+(instancetype) buttonTitleFontColor{
    return [UIColor whiteColor];
}

#pragma mark NSDCustomColors

+(instancetype) goldColor{
    return [UIColor colorWithRed:255.0/255.0 green:215.0/255.0 blue:0.0/255.0 alpha:1.0];
}

+(instancetype) silverColor{
    return [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];

}

+(instancetype) bronzeColor{
    return [UIColor colorWithRed:205.0/255.0 green:127.0/255.0 blue:50.0/255.0 alpha:1.0];

}



@end
