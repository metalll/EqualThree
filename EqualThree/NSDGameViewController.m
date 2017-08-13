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
#import "NSDHighscoresManager.h"
#import "NSDGameSharedManager.h"
#import "NSDReplayRecorder.h"

NSString * const NSDUserDidTapHintButton = @"NSDUserDidTapHintButton";

@interface NSDGameViewController ()

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *movesLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

- (void)setNavigationBarHidden:(BOOL)hidden;
- (void)subscribeToNotifacations;
- (void)unsubscribeFromNotifacations;
- (void)notifyAboutUserDidTapHintButton;
- (void)didUpdateUserScore:(NSNotification *)notification;
- (void)didUpdateUserSharedScore:(NSNotification *)notification;
- (void)didUpdateMovesCount:(NSNotification *)notification;
- (void)didDetectGameOver:(NSNotification *) notification;

@end


@implementation NSDGameViewController

#pragma mark - Life Cycle

- (void)viewDidLoad{
    
    [super viewDidLoad];
    [self subscribeToNotifacations];
    
    self.movesLabel.text = @"0";
    self.scoreLabel.text = @"0";
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self setNavigationBarHidden:NO];
}

- (void)dealloc{
    
    [self unsubscribeFromNotifacations];
}

#pragma mark - Actions

- (IBAction)didTapMenuButton:(id)sender{
    
    [NSDAlertView showAlertWithMessageText:@"Paused"
                        andFirstButtonText:@"Resume"
                       andSecondButtonText:@"Exit"
                       andFirstButtonBlock:^{
                       } andSecondButtonBlock:^{
                           [self.navigationController popViewControllerAnimated:YES];
                       } andParentViewController:self];
}

- (IBAction)didTapHintButton:(id)sender {
    
    [self notifyAboutUserDidTapHintButton];
}

#pragma mark - Private

- (void)setNavigationBarHidden:(BOOL)hidden{
    
    [self.navigationController setNavigationBarHidden:hidden animated:YES];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = !hidden;
    }
}

#pragma mark - Notifications

- (void)subscribeToNotifacations{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateMovesCount:) name:NSDDidUpdateMovesCount object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateUserScore:) name:NSDGameFieldDidEndDeletingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateUserSharedScore:) name:NSDDidUpdadeSharedUserScore object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDetectGameOver:) name:NSDDidDetectGameOver object:nil];
}

- (void)unsubscribeFromNotifacations{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)notifyAboutUserDidTapHintButton{
    
    NSNotification *notification = [NSNotification notificationWithName:NSDUserDidTapHintButton object:nil] ;
    [[NSNotificationCenter defaultCenter]postNotification:notification];
}

- (void)didUpdateUserScore:(NSNotification *)notification{
    
    NSUInteger resivedScore  = [notification.userInfo[kNSDDeletedItemsCost] unsignedIntegerValue];
    NSUInteger currentScore = [self.scoreLabel.text integerValue];
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)resivedScore + currentScore];
}

- (void)didUpdateUserSharedScore:(NSNotification *)notification{
    
    NSUInteger recivedScore = [notification.userInfo[kNSDUserScore] unsignedIntegerValue];
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)recivedScore];
}

- (void)didUpdateMovesCount:(NSNotification *)notification{
    
    NSUInteger recivedMovesCount = [notification.userInfo[kNSDMovesCount] unsignedIntegerValue];
    
    self.movesLabel.text = [NSString stringWithFormat:@"%ld",(long)recivedMovesCount];
}

- (void)didDetectGameOver:(NSNotification *) notification{
    
    NSDGameOverViewController *gameOverVC = [[NSDGameOverViewController alloc] initWithCompletion:^(NSDScoreRecord * record) {
        
        [[NSDGameSharedManager sharedInstance] deleteGame];
        [[NSDHighscoresManager sharedManager] addRecordWithRecord:record];
        
        record.replayID = [record hash];
        [[NSDReplayRecorder sharedInstance] stopRecording];
        [[NSDReplayRecorder sharedInstance] saveReplayWithID:record.replayID];
        
        
        [self dismissViewControllerAnimated:YES completion:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }];
    
    gameOverVC.movesText = [notification.userInfo[kNSDMovesCount] stringValue];
    gameOverVC.scoreText = [notification.userInfo[kNSDUserScore] stringValue];
    
    [self presentViewController:gameOverVC animated:YES completion:nil];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"InitGameField"]){
        ((NSDGameFieldViewController *)segue.destinationViewController).isNewGame = self.isNewGame;
    }
}

@end
