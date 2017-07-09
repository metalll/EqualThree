//
//  NSDGeneralMenuViewController.m
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGeneralMenuViewController.h"
#import "NSDToastView.h"
#import "UIColor+NSDColor.h"



@interface NSDGeneralMenuViewController (){
    NSDToastView * toast;
}
@property (weak, nonatomic) IBOutlet UIView *mainView;


@end

@implementation NSDGeneralMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Menu";
    
    self.navigationController.navigationBar.translucent = NO;
    
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setBarTintColor:[UIColor navigationBackgroundColor]];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [bar setTintColor:[UIColor whiteColor]];
    
    
    toast = [NSDToastView new];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:isFirstLaunch]){
       
        [toast displayOnView:_mainView withMessage:@"Welcome back" andColor:[UIColor toastSimpleColor] andIndicator:NO andFaded:YES];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:isFirstLaunch];
         [toast displayOnView:_mainView withMessage:@"Welcome to EqualThree" andColor:[UIColor toastSimpleColor] andIndicator:NO andFaded:YES];
    }
}

@end
