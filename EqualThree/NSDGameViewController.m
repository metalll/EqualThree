    //
//  NSDGameViewController.m
//  EqualThree
//
//  Created by NSD on 13.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGameViewController.h"
#import "NSDGameViewController.h"
#import "UIColor+NSDColor.h"
#import "NSDGeneralMenuViewController.h"
#import "NSDAlertView.h"
#import "NSDGameEngine.h"
#import "NSDGameFieldViewController.h"
#import "NSDGameOverViewController.h"

NSString * const NSDUserDidTapHintButton = @"NSDUserDidTapHintButton";

@interface NSDGameViewController ()


@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *moviesLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation NSDGameViewController

- (void)viewDidLoad {

    
    [super viewDidLoad];
    [self subscribeToNotifacations];
    
    self.moviesLabel.text = @"0";
    self.scoreLabel.text = @"0";
    
    
}
- (IBAction)didTapMenuButton:(id)sender {
    
    [NSDAlertView showAlertWithMessageText:@"Paused"
                        andFirstButtonText:@"Resume"
                       andSecondButtonText:@"Exit"
                       andFirstButtonBlock:^{
                       } andSecondButtonBlock:^{
                           [self.navigationController popViewControllerAnimated:YES];
                       } andParentViewController:self];
    
    
}

- (IBAction)didTapHintButton:(id)sender {
    
    NSNotification * notification = [NSNotification notificationWithName:NSDUserDidTapHintButton object:nil] ;
    [[NSNotificationCenter defaultCenter]postNotification:notification];
}


-(void) subscribeToNotifacations{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateMoviesCount:) name:NSDDidUpdateMovesCount object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateUserScore:) name:NSDGameDidFieldEndDeleting object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateUserSharedScore:) name:NSDDidUpdadeSharedUserScore object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDetectGameOver:) name:NSDDidDetectGameOver object:nil];
    
    
}

-(void) unsubscribeFromNotifacations{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)dealloc{
    [self unsubscribeFromNotifacations];
}


-(void)didUpdateUserScore:(NSNotification *)notification{
    NSUInteger resivedScore  = [notification.userInfo[kNSDCostDeletedItems] unsignedIntegerValue];
    NSUInteger currentScore = [self.scoreLabel.text integerValue];
    
    
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)resivedScore+currentScore];
    
    
    
}

-(void)didUpdateUserSharedScore:(NSNotification *)notification{
    NSUInteger resivedScore  = [notification.userInfo[kNSDUserScore] unsignedIntegerValue];
  
    
    
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)resivedScore];
    
    
    
}

-(void)didUpdateMoviesCount:(NSNotification *)notification{
    NSUInteger resivedMoviesCount = [notification.userInfo[kNSDMovesCount] unsignedIntegerValue];
    
    self.moviesLabel.text  = [NSString stringWithFormat:@"%ld",(long)resivedMoviesCount];
}



-(void) didDetectGameOver:(NSNotification *) notification{
    
    
    NSDGameOverViewController * gameOverVC = [[NSDGameOverViewController alloc] initWithCompletion:^(NSDScoreRecord * record) {
        
        
        //to do delete last session
        
        
        
        
        
    }];
    
    
    
    gameOverVC.movesText = [notification.userInfo[kNSDMovesCount] stringValue];
    gameOverVC.scoreText = [notification.userInfo[kNSDUserScore] stringValue];
    
    
    
    
    [self presentViewController:gameOverVC animated:YES completion:nil];
    
    

}


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;

    }
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"InitGameField"]){
        
        ((NSDGameFieldViewController *)segue.destinationViewController).isNewGame =  self.isNewGame;

    }
    
}


@end
