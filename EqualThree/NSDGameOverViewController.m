//
//  NSDGameOverViewController.m
//  EqualThree
//
//  Created by NSD on 05.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGameOverViewController.h"

@interface NSDGameOverViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerXConstraint;

@end

@implementation NSDGameOverViewController




-(instancetype)init{

    self = [super init];
    
    
    if(self){
        
        
    [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShow:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidHide:)
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];

        
    }
    
    

    
    
    return self;

}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Listen for keyboard appearances and disappearances
    self.mainView.layer.cornerRadius = 20.0f;
    self.mainView.layer.masksToBounds = YES;
    self.nameTextField.delegate = self;
    

    
    // Do any additional setup after loading the view from its nib.
}




-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

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

- (IBAction)didTapOkButton:(id)sender {
    
    NSString * checkingText = self.nameTextField.text;
    
    if(checkingText==nil|| !(checkingText.length>0)){
        
        self.errorLabel.alpha = 1.0f;
        
        
        
        return;
        
    
    
    }
    
    
    
    
    
    [self.view endEditing:YES];
    [self.nameTextField endEditing:YES];

    
    
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    
    NSLog(@" r string %@",string);
    
    NSInteger replasmentStringSize = 0;
    
    if(string.length>0){
    
        replasmentStringSize = string.length;
        
    }else{
        replasmentStringSize = -1;
    }
    
    
    if(textField.text==nil|| !((textField.text.length + replasmentStringSize) >0)){
    
        self.errorLabel.alpha = 1.0f;
    
    }else{
    
        self.errorLabel.alpha = 0.0f;
    }
    
    
    return YES;

}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.centerXConstraint.constant = -127.0f;
    
    [UIView animateWithDuration:0.2f animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.centerXConstraint.constant = 0;
    
    [UIView animateWithDuration:0.2f animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    


}

- (void)keyboardDidShow: (NSNotification *) notif{
    // Do something here

    
  
    
    

    
    
    
    
    
    
}

- (void)keyboardDidHide: (NSNotification *) notif{
    
  
    
        
   
    

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
