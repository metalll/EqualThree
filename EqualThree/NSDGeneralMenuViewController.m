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
#import "NSDGameSharedManager.h"


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

    
    [[NSDGameSharedManager sharedInstance] hasSavedGameWithCompletion:^(BOOL isHasSavedGame) {
        
        [self.resumeButton setEnabled:isHasSavedGame];
        
    }];
    
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setBarTintColor:[UIColor navigationBackgroundColor]];
    [bar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Noteworthy-Bold" size:20.0f],
                                  NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [bar setTintColor:[UIColor whiteColor]];

    
    
    
}

-(void)viewDidAppear:(BOOL)animated{

    if([[NSDGameSharedManager sharedInstance] lastSavedGame]==nil){
        [self.resumeButton setEnabled:NO];
    }
    else {
        [self.resumeButton setEnabled:YES];
    }
    
    self.isNewGame = NO;
    
    [super viewDidAppear:animated];
    
}



#pragma mark - Actions

- (IBAction)didTapNewGameButtonWithSender:(id)sender {
    
    if([[NSDGameSharedManager sharedInstance] lastSavedGame]!=nil){
        
        [NSDAlertView showAlertWithMessageText:@"Do you really want to start a new game?\nAll progress will be lost."
                          andFirstButtonText:@"Yes"
                         andSecondButtonText:@"No"
                         andFirstButtonBlock:^{
                             
                             //todo refactor to seque;
                             self.isNewGame = YES;
                             [self performSegueWithIdentifier:@"ShowGameViewController" sender:self];
                             
                         } andSecondButtonBlock:^{
                         } andParentViewController:self];
    }
    else {
        self.isNewGame = YES;
        [self performSegueWithIdentifier:@"ShowGameViewController" sender:self];
        
    }
    
    
    
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    
    if([segue.identifier isEqualToString:@"ShowGameViewController"]){
        ((NSDGameViewController *)segue.destinationViewController).isNewGame = self.isNewGame ;
        
    }
    
    [super prepareForSegue:segue sender:sender];
    
    
    
    
}



@end
