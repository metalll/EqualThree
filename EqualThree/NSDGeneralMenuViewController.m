//
//  NSDGeneralMenuViewController.m
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGeneralMenuViewController.h"
#import "NSDToastView.h"
#import "UIColor+NSDColor.h"
#import "NSDEqualThreeGameViewController.h"


@interface NSDGeneralMenuViewController (){
    NSDToastView * toast;
}
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIButton *resumeButton;

@end

@implementation NSDGeneralMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Menu";
    
    self.navigationController.navigationBar.translucent = NO;
    
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setBarTintColor:[UIColor navigationBackgroundColor]];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [bar setTintColor:[UIColor whiteColor]];
    
    
    toast = [NSDToastView new];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:isFirstLaunch]){
       
        [toast displayOnView:_mainView withMessage:@"Welcome back" andColor:[UIColor toastSimpleColor] andIndicator:NO andFaded:YES];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:isFirstLaunch];
         [toast displayOnView:_mainView withMessage:@"Welcome to EqualThree" andColor:[UIColor toastSimpleColor] andIndicator:NO andFaded:YES];
    }
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{
                                                              isHasSavedGame:@NO
                                                }];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:isHasSavedGame]){
    
        
        [_resumeButton setEnabled:NO];
        [_resumeButton setAlpha:0.5f];
    }else{
        [_resumeButton setEnabled:YES];
        [_resumeButton setAlpha:1.0f];
        
    }
    
}

-(void)viewDidAppear:(BOOL)animated{

    if([[NSUserDefaults standardUserDefaults] objectForKey:isHasSavedGame]){
        
        
        [_resumeButton setEnabled:NO];
        [_resumeButton setAlpha:0.5f];
    }else{
        [_resumeButton setEnabled:YES];
        [_resumeButton setAlpha:1.0f];
        
    }

    
    [super viewDidAppear:animated];
    
}

- (IBAction)didTapNewGameButtonWithSender:(id)sender {
    

    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:isHasSavedGame] isEqual:@NO]){
    
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Create new game"
                                                                       message:@"Are you sure?"
                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* allowAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                              
                                                                  
                                                                  NSDEqualThreeGameViewController * target = [self.storyboard instantiateViewControllerWithIdentifier:@"EqualThreeGameViewController"];
                                                                  
                                                                  [self.navigationController presentViewController:target animated:YES completion:nil];
                                                                  

                                                                  
                                                              }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action) {}];

        
        [alert addAction:cancelAction];
        [alert addAction:allowAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    
    }else{
        
        NSDEqualThreeGameViewController * target = [self.storyboard instantiateViewControllerWithIdentifier:@"EqualThreeGameViewController"];
        
        [self.navigationController presentViewController:target animated:YES completion:nil];
        
        
        

    }
    
    
    
    
}



@end



