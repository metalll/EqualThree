//
//  NSDGameViewController.m
//  EqualThree
//
//  Created by NSD on 13.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGameViewController.h"
#import "NSDToastView.h"
#import "UIColor+NSDColor.h"
#import "NSDGeneralMenuViewController.h"
#import "NSDAlertView.h"

@interface NSDGameViewController ()
@property NSDToastView * toast;

@property (weak, nonatomic) IBOutlet UIView *mainView;

@end

@implementation NSDGameViewController

- (void)viewDidLoad {

    self.toast = [NSDToastView new];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:kIsHasSavedGame] isEqual:@YES ]){
        [self.toast displayOnView:_mainView withMessage:@"Resume game" andColor:[UIColor toastSimpleColor] andIndicator:NO andFaded:YES andIsHasTopBar:NO];
        
    }else{
        [self.toast displayOnView:_mainView withMessage:@"New game" andColor:[UIColor toastAcceptColor] andIndicator:NO andFaded:YES andIsHasTopBar:NO];
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:kIsHasSavedGame];
    }
    
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
