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
    // Listen for keyboard appearances and disappearances
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    
    // Do any additional setup after loading the view from its nib.
}




-(void)viewWillAppear:(BOOL)animated{
    self.movesLabel.text = self.movesText;
    self.scoreLabel.text = self.scoreText;

    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)keyboardDidShow: (NSNotification *) notif{
    // Do something here
    
    [UIView animateWithDuration:0.1f animations:^{
      
        
    
        CGRect rect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 150, self.view.frame.size.width, self.view.frame.size.height);
        
        self.view.frame = rect;
        
        
    }];
    
    
    
    
    
    
    
}

- (void)keyboardDidHide: (NSNotification *) notif{
    [UIView animateWithDuration:0.1f animations:^{
        
        
        
        CGRect rect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 150, self.view.frame.size.width, self.view.frame.size.height);
        
        self.view.frame = rect;
        
        
    }];
    

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
