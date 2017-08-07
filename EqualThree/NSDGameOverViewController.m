//
//  NSDGameOverViewController.m
//  EqualThree
//
//  Created by NSD on 05.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGameOverViewController.h"
#import "UIColor+NSDColor.h"

float const heightTranstionToDisplayKeyboard = -134.0f;

@interface NSDGameOverViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerYConstraint;
@property (nonatomic,copy) NSDCompletion completionBlock;

@end

@implementation NSDGameOverViewController

#pragma mark - Constructors

- (instancetype)initWithCompletion:(NSDCompletion)completion{
    
    self = [super init];
    
    if(self){
        [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
       
        self.completionBlock = completion;
        [self.view setBackgroundColor:[UIColor alertBackroundColor]];
        
    }
    
    return self;
    
}

#pragma mark - Life Cycle

- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.mainView.layer.cornerRadius = 20.0f;
    self.mainView.layer.masksToBounds = YES;
    self.nameTextField.delegate = self;
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.movesLabel.text = self.movesText;
    self.scoreLabel.text = self.scoreText;
}

#pragma mark - Actions

- (IBAction)didTapOkButton:(id)sender{
    
    NSString * checkingText = self.nameTextField.text;
    
    if(checkingText==nil|| !(checkingText.length>0)){
        
        self.errorLabel.alpha = 1.0f;
        return;
    }
    
    [self.view endEditing:YES];
    [self.nameTextField endEditing:YES];
    
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSNumber *score = [f numberFromString:self.scoreText];
    
    self.completionBlock([[NSDScoreRecord alloc]initWithName:checkingText score:score]);
    
}


#pragma mark - Text Field Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSInteger replacementStringSize = 0;
    
    if(string.length>0){
        
        replacementStringSize = string.length;
    }else{
        
        replacementStringSize = -1;
    }
    
    if(textField.text == nil || !((textField.text.length + replacementStringSize) > 0)){
        self.errorLabel.alpha = 1.0f;
    }else{
        self.errorLabel.alpha = 0.0f;
    }
    
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.centerYConstraint.constant = heightTranstionToDisplayKeyboard;
    
    [UIView animateWithDuration:0.2f animations:^{
        [self.view layoutIfNeeded];
    }];
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.centerYConstraint.constant = 0;
    
    [UIView animateWithDuration:0.2f animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
