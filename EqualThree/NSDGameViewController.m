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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _toast = [[NSDToastView alloc] init];
    
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:isHasSavedGame] isEqual:@YES ]){
        
        [_toast displayOnView:_mainView withMessage:@"Resume game" andColor:[UIColor toastSimpleColor] andIndicator:NO andFaded:YES andIsHasTopBar:NO];
        
        
        
    }else{
        
        [_toast displayOnView:_mainView withMessage:@"New game" andColor:[UIColor toastAcceptColor] andIndicator:NO andFaded:YES andIsHasTopBar:NO];
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:isHasSavedGame];
        
        
    }
    

    
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
