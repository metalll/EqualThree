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

@implementation NSDReplayViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"ConfigureGameFieldToPlayReplay"]){
        
        NSDGameFieldViewController * gameFieldVC = (NSDGameFieldViewController *)segue.destinationViewController;
        
        gameFieldVC.isReplay = YES;
        gameFieldVC.replayID = self.replayID;
        
    }
}

@end
