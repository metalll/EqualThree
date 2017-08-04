//
//  NSDGameOverViewController.m
//  EqualThree
//
//  Created by NSD on 05.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGameOverViewController.h"

@interface NSDGameOverViewController ()

@end

@implementation NSDGameOverViewController




-(instancetype)init{

    self = [super init];
    
    
    if(self){

    [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
        
    }
    
    
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
