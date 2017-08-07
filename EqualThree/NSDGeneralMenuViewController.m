//
//  NSDGeneralMenuViewController.m
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGeneralMenuViewController.h"
#import "UIColor+NSDColor.h"
#import "NSDGameViewController.h"
#import "NSDAlertView.h"
#import "NSDGameSharedManager.h"
#import "NSDHighscoresManager.h"



@interface NSDGeneralMenuViewController ()


@property (weak, nonatomic) IBOutlet UIButton* resumeButton;

-(void)startNewGame;

@end


@implementation NSDGeneralMenuViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"Menu";
    self.navigationController.navigationBar.translucent = NO;
    
    [self.resumeButton setEnabled:NO];
    
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setBarTintColor:[UIColor navigationBackgroundColor]];
    [bar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Noteworthy-Bold" size:20.0f],
                                  NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [bar setTintColor:[UIColor navigationForegroundColor]];
    
    
    [[NSDGameSharedManager sharedInstance] hasSavedGameWithCompletion:^(BOOL hasSavedGame) {
        [self.resumeButton setEnabled:hasSavedGame];
    }];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    if([[NSDGameSharedManager sharedInstance] lastSavedGame]==nil){
        [self.resumeButton setEnabled:NO];
    }
    else {
        [self.resumeButton setEnabled:YES];
    }
    
    [super viewDidAppear:animated];
    
}



#pragma mark - Actions

- (IBAction)didTapNewGameButtonWithSender:(id)sender{
    
    if([[NSDGameSharedManager sharedInstance] lastSavedGame]!=nil){
        
        [NSDAlertView showAlertWithMessageText:@"Do you really want to start a new game?\nAll progress will be lost."
                            andFirstButtonText:@"Yes"
                           andSecondButtonText:@"No"
                           andFirstButtonBlock:^{
                               
                               [self startNewGame];
                               
                               
                           } andSecondButtonBlock:^{
                           } andParentViewController:self];
    }
    else {
        [self startNewGame];
    }
}

#pragma mark - Private

-(void)startNewGame{
    
    [self performSegueWithIdentifier:@"NewGameViewController" sender:self];
    
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"NewGameViewController"]){
        ((NSDGameViewController *)segue.destinationViewController).isNewGame = YES ;
    }
    
    [super prepareForSegue:segue sender:sender];
}

@end
