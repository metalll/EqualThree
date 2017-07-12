//
//  NSDAlertView.h
//  EqualThree
//
//  Created by NSD on 13.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDAlertView : UIViewController

typedef void(^NSDAlertButtonBlock)(void);

+ (void)showAlertWithMessageText:(NSString*)messageText
              andFirstButtonText:(NSString*)firstButtonText
             andSecondButtonText:(NSString*)secondButtonText
             andFirstButtonBlock:(NSDAlertButtonBlock)firstButtonBlock
            andSecondButtonBlock:(NSDAlertButtonBlock)secondButtonBlock
         andParentViewController:(UIViewController*) parentVC;
;

- (instancetype)initWithMessageText:(NSString*)messageText
                 andFirstButtonText:(NSString*)firstButtonText
                andSecondButtonText:(NSString*)secondButtonText
                andFirstButtonBlock:(NSDAlertButtonBlock)firstButtonBlock
               andSecondButtonBlock:(NSDAlertButtonBlock)secondButtonBlock;

- (void)showWithParentViewController:(UIViewController*) parentVC;

@end
