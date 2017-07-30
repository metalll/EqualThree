//
//  NSDGeneralMenuViewController.m
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGeneralMenuViewController.h"

#import "UIColor+NSDColor.h"
#include "NSDGameViewController.h"
#import "NSDAlertView.h"



@interface NSDGeneralMenuViewController ()


@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIButton *resumeButton;

@end


NSString * const kIsHasSavedGame = @"NSDIsHasSavedGame";
NSString * const kIsFirstLaunch = @"NSDIsFirstLaunch";

@implementation NSDGeneralMenuViewController



#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Menu";
    self.navigationController.navigationBar.translucent = NO;

    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setBarTintColor:[UIColor navigationBackgroundColor]];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [bar setTintColor:[UIColor whiteColor]];

   
    
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{
                                                              kIsHasSavedGame:@NO}];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:kIsHasSavedGame] isEqual:@NO]){
        [self.resumeButton setEnabled:NO];
        [self.resumeButton setAlpha:0.5f];
    }else{
        [self.resumeButton setEnabled:YES];
        [self.resumeButton setAlpha:1.0f];
        
    }
    
}

-(void)viewDidAppear:(BOOL)animated{

    if([[[NSUserDefaults standardUserDefaults] objectForKey:kIsHasSavedGame] isEqual:@NO]){
        [self.resumeButton setEnabled:NO];
        [self.resumeButton setAlpha:0.5f];
    }
    else {
        [self.resumeButton setEnabled:YES];
        [self.resumeButton setAlpha:1.0f];
    }
    
    [super viewDidAppear:animated];
    
}



#pragma mark - Actions

- (IBAction)didTapNewGameButtonWithSender:(id)sender {
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:kIsHasSavedGame] isEqual:@YES]){
        
        [NSDAlertView showAlertWithMessageText:@"Do you really want to start a new game?\nAll progress will be lost."
                          andFirstButtonText:@"Yes"
                         andSecondButtonText:@"No"
                         andFirstButtonBlock:^{
                             [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:kIsHasSavedGame];
                             
                             //todo refactor to seque;
                             
                             NSDGameViewController * target = [self.storyboard instantiateViewControllerWithIdentifier:@"NSDGameViewController"];
                             
                             [self.navigationController pushViewController:target animated:YES];
                             
                         } andSecondButtonBlock:^{
                         } andParentViewController:self];
    }
    else {
        NSDGameViewController * target = [self.storyboard instantiateViewControllerWithIdentifier:@"NSDGameViewController"];
        [self.navigationController pushViewController:target animated:YES];
    }
    
    
    
    
}



@end
