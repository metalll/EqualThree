//
//  NSDReplayViewController.m
//  EqualThree
//
//  Created by NSD on 13.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDReplayViewController.h"
#import "NSDReplayPlayer.h"

@implementation NSDReplayViewController


- (void)viewDidLoad{

    [super viewDidLoad];
    
    [[NSDReplayPlayer sharedInstance] playReplayWithID:self.replayID];
}

@end
