//
//  NSDGeneralMenuViewController.h
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <UIKit/UIKit.h>



extern NSString * const kIsHasSavedGame;
extern NSString * const kIsFirstLaunch;

@interface NSDGeneralMenuViewController : UIViewController

@property BOOL isNewGame ;

- (IBAction)didTapNewGameButtonWithSender:(id)sender ;

@end
