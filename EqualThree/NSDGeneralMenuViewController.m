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
#include "NSDGameViewController.h"
#import "NSDAlertView.h"


@interface NSDGeneralMenuViewController (){
    NSDToastView * toast;
}
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIButton *resumeButton;

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
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{
                                                              isHasSavedGame:@NO
                                                }];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:isHasSavedGame] isEqual:@NO]){
    
        
        [_resumeButton setEnabled:NO];
        [_resumeButton setAlpha:0.5f];
    }else{
        [_resumeButton setEnabled:YES];
        [_resumeButton setAlpha:1.0f];
        
    }
    
}

-(void)viewDidAppear:(BOOL)animated{

    if([[[NSUserDefaults standardUserDefaults] objectForKey:isHasSavedGame] isEqual:@NO]){
        
        
        [_resumeButton setEnabled:NO];
        [_resumeButton setAlpha:0.5f];
    }else{
        [_resumeButton setEnabled:YES];
        [_resumeButton setAlpha:1.0f];
        
    }

    
    [super viewDidAppear:animated];
    
}

- (IBAction)didTapNewGameButtonWithSender:(id)sender {
    

    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:isHasSavedGame] isEqual:@YES]){
        
        
        
        [NSDAlertView showAlertWithMessageText:@"Do you really want to start a new game?\nAll progress will be lost."
                          andFirstButtonText:@"Yes"
                         andSecondButtonText:@"No"
                         andFirstButtonBlock:^{
                             
                             
                             [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:isHasSavedGame];
                             
                             
                             NSDGameViewController * target = [self.storyboard
                                                               instantiateViewControllerWithIdentifier:@"NSDGameViewController"];
                             
                             [self.navigationController presentViewController:target animated:YES completion:nil];

                             
                             
                         } andSecondButtonBlock:^{
                             
                             
                             
                         } andParentViewController:self];
    }
        
        

    
    else{
        NSDGameViewController * target = [self.storyboard
                                                instantiateViewControllerWithIdentifier:@"NSDGameViewController"];
        
        [self.navigationController presentViewController:target animated:YES completion:nil];
        
        
        

    }
    
    
    
    
}



@end



