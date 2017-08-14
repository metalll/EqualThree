//
//  NSDReplayViewController.m
//  EqualThree
//
//  Created by NSD on 13.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDReplayViewController.h"
#import "NSDReplayPlayer.h"
#import "NSDGameFieldViewController.h"
#import "NSDAlertView.h"

@interface NSDReplayViewController()

@property BOOL isUserAgree;

- (void)subscribeToNotifications;
- (void)didDetectEndPlayingReplay;
- (void)unsubscribeFromNotifications;


@end

@implementation NSDReplayViewController

#pragma mark - Life Cycle

- (void)viewDidLoad{
    
    [super viewDidLoad];
    [self subscribeToNotifications];
    
    [NSDAlertView showAlertWithMessageText:@"This is not a tested functional.\nContinue?"
                        andFirstButtonText:@"Yes"
                       andSecondButtonText:@"No"
                       andFirstButtonBlock:^{
                           
                           self.isUserAgree = YES;
                           [self performSegueWithIdentifier:@"ConfigureGameFieldToPlayReplay" sender:self];
                       }
                      andSecondButtonBlock:^{
                          [[self navigationController] popViewControllerAnimated:YES];
                          
                      } andParentViewController:self
                            andDismissible:NO];
    
    
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [[NSDReplayPlayer sharedInstance] stopReplay];
    
}

-(void)dealloc{
    
    [self unsubscribeFromNotifications];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"ConfigureGameFieldToPlayReplay"]&&self.isUserAgree){
        
        NSDGameFieldViewController * gameFieldVC = (NSDGameFieldViewController *)segue.destinationViewController;
        
        gameFieldVC.isReplay = YES;
        gameFieldVC.replayID = self.replayID;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    return self.isUserAgree;
}

#pragma mark - Notifications

- (void)subscribeToNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDetectEndPlayingReplay) name:NSDGameFieldEndPlayingReplay object:nil];
}

- (void)unsubscribeFromNotifications{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didDetectEndPlayingReplay{
    
    [NSDAlertView showAlertWithMessageText:@"Replay playback complete.\nBack to the highscore table?"
                        andFirstButtonText:@"Yes"
                       andSecondButtonText:@"No"
                       andFirstButtonBlock:^{
                           
                           [self.navigationController popViewControllerAnimated:YES];
                       }
                      andSecondButtonBlock:^{
                      } andParentViewController:self];
}

@end
