//
//  NSDGameViewController.m
//  EqualThree
//
//  Created by NSD on 13.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGameViewController.h"

#import "UIColor+NSDColor.h"
#import "NSDGeneralMenuViewController.h"
#import "NSDAlertView.h"
#import "NSDGameEngine.h"


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
                           [self dismissViewControllerAnimated:YES completion:nil];
                       } andParentViewController:self];
    
    
}



-(void) subscribeToNotifacations{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateMoviesCount:) name:NSDDidUpdateMoviesCount object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateUserScore:) name:NSDDidUpdateUserScore object:nil];
    
    
    
}

-(void) unsubscribeFromNotifacations{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)dealloc{
    [self unsubscribeFromNotifacations];
}


-(void)didUpdateUserScore:(NSNotification *)notification{
    NSUInteger resivedScore  = [notification.userInfo[kNSDUserScore] unsignedIntegerValue];
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)resivedScore];
    
    
    
}

-(void)didUpdateMoviesCount:(NSNotification *)notification{
    NSUInteger resivedMoviesCount = [notification.userInfo[kNSDMoviesCount] unsignedIntegerValue];
    
    self.moviesLabel.text  = [NSString stringWithFormat:@"%ld",(long)resivedMoviesCount];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];


    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;

    }
    
}



@end
