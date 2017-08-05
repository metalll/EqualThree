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


- (void)keyboardDidShow: (NSNotification *) notif{
    // Do something here

    
    [UIView animateWithDuration:0.12f animations:^{
        CGRect rect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 150, self.view.frame.size.width, self.view.frame.size.height);
        
        self.view.frame = rect;
    } completion:^(BOOL finished) {
        
    }];
    
    

    
    
    
    
    
    
}

- (void)keyboardDidHide: (NSNotification *) notif{
    
    [UIView animateWithDuration:0.12f animations:^{
        CGRect rect = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        self.view.frame = rect;
    } completion:^(BOOL finished) {
        
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
