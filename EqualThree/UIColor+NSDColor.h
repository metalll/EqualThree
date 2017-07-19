//
//  UIColor+NSDColor.h
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (NSDColor)


#pragma mark NSDToastColors

+(instancetype) toastAcceptColor;
+(instancetype) toastErrorColor;
+(instancetype) toastSimpleColor;

#pragma mark NSDNavColors

+(instancetype) navigationBackgroundColor;


+(instancetype) buttonBackgroundColor;

+(instancetype) buttonTitleFontColor;



+(instancetype) goldColor;

+(instancetype) silverColor;

+(instancetype) bronzeColor;

@end
