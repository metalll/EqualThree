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
- (void)didDetectEndPlayingReplay;
@end

@implementation NSDReplayViewController

#pragma mark - Life Cycle

- (void)viewDidLoad{
    
    [super viewDidLoad];
    [self subscribeToNotifications];
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
    
    if([segue.identifier isEqualToString:@"ConfigureGameFieldToPlayReplay"]){
        
        NSDGameFieldViewController * gameFieldVC = (NSDGameFieldViewController *)segue.destinationViewController;
        
        gameFieldVC.isReplay = YES;
        gameFieldVC.replayID = self.replayID;
    }
}

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
