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
#import "NSDButton.h"

NSInteger NSDHeightAnimationTrasition = -120;

@interface NSDGeneralMenuViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *treeLabelYConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *equalLabelYConstraint;

@property (weak, nonatomic) IBOutlet UIButton *resumeButton;

@property (weak, nonatomic) IBOutlet NSDButton *btn;

@property (weak, nonatomic) IBOutlet NSDButton *highscoreButton;

- (void)startNewGame;

@end


@implementation NSDGeneralMenuViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBarHidden  = YES;
    
    self.equalLabelYConstraint.constant = NSDHeightAnimationTrasition;
    self.treeLabelYConstraint.constant = NSDHeightAnimationTrasition;
    
    [UIView animateWithDuration:0.6f animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [self.resumeButton setEnabled:NO];
    
    [[NSDGameSharedManager sharedInstance] hasSavedGameWithCompletion:^(BOOL hasSavedGame) {
        [self.resumeButton setEnabled:hasSavedGame];
    }];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
      [super viewDidAppear:animated];
    
    if([[NSDGameSharedManager sharedInstance] lastSavedGame]==nil){
        
        [self.resumeButton setEnabled:NO];
    }
    else {
        
        [self.resumeButton setEnabled:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden  = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden  = NO;
}


#pragma mark - Actions

- (IBAction)didTapNewGameButtonWithSender:(id)sender{
    
    if([[NSDGameSharedManager sharedInstance] lastSavedGame]!=nil){
        
        [NSDAlertView showAlertWithMessageText:@"Do you really want to start a new game?\nAll progress will be lost."
                            andFirstButtonText:@"Yes"
                           andSecondButtonText:@"No"
                           andFirstButtonBlock:^{
                               
                               [self startNewGame];
                           }
                          andSecondButtonBlock:^{
                          } andParentViewController:self];
    }
    else {
        [self startNewGame];
    }
}

#pragma mark - Private

- (void)startNewGame{
    
    [self performSegueWithIdentifier:@"NewGameViewController" sender:self];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"NewGameViewController"]){
        ((NSDGameViewController *)segue.destinationViewController).isNewGame = YES ;
    }
    
    [super prepareForSegue:segue sender:sender];
}

@end
