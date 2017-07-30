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

@interface NSDGameViewController ()


@property (weak, nonatomic) IBOutlet UIView *mainView;

@end

@implementation NSDGameViewController

- (void)viewDidLoad {

    
    [super viewDidLoad];
    
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

@end
