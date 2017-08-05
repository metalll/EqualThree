//
//  NSDAlertView.m
//  EqualThree
//
//  Created by NSD on 13.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDAlertView.h"
#import "UIColor+NSDColor.h"
@interface NSDAlertView ()


@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;

@property (nonatomic, strong) NSString *messageText;
@property (nonatomic, strong) NSString *firstButtonText;
@property (nonatomic, strong) NSString *secondButtonText;

@property (nonatomic, copy) NSDAlertButtonBlock firstButtonBlock;
@property (nonatomic, copy) NSDAlertButtonBlock secondButtonBlock;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *alertView;


@end

@implementation NSDAlertView




#pragma mark - Convinience Methods

+ (void)showAlertWithMessageText:(NSString*)messageText
                 andFirstButtonText:(NSString*)firstButtonText
                andSecondButtonText:(NSString*)secondButtonText
                andFirstButtonBlock:(NSDAlertButtonBlock)firstButtonBlock
               andSecondButtonBlock:(NSDAlertButtonBlock)secondButtonBlock
                andParentViewController:(UIViewController*) parentVC;
{
    
    NSDAlertView *alert = [[NSDAlertView alloc] initWithMessageText:messageText
                                          andFirstButtonText:firstButtonText
                                         andSecondButtonText:secondButtonText
                                         andFirstButtonBlock:firstButtonBlock
                                        andSecondButtonBlock:secondButtonBlock];
    [alert.view setBackgroundColor:[UIColor alertBackroundColor]];
    
    [alert showWithParentViewController:parentVC];
}

#pragma mark - Constructors

- (instancetype)initWithMessageText:(NSString*)messageText
                    andFirstButtonText:(NSString*)firstButtonText
                   andSecondButtonText:(NSString*)secondButtonText
                   andFirstButtonBlock:(NSDAlertButtonBlock)firstButtonBlock
                  andSecondButtonBlock:(NSDAlertButtonBlock)secondButtonBlock {
    self = [super init];
    if (self) {
        self.messageText = messageText;
        self.firstButtonText = firstButtonText;
        self.secondButtonText = secondButtonText;
        self.firstButtonBlock = firstButtonBlock;
        self.secondButtonBlock = secondButtonBlock;
    }
    return self;
}

#pragma mark - Lifecicle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.alertView.layer.cornerRadius = 20.0f;
    self.alertView.layer.masksToBounds = YES;
    
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //self.modalPresentationStyle = UIModalPresentationFormSheet;
    
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    self.messageLabel.text = self.messageText;
    [self.firstButton setTitle:self.firstButtonText forState:UIControlStateNormal];
    [self.secondButton setTitle:self.secondButtonText forState:UIControlStateNormal];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [_mainView addGestureRecognizer:singleFingerTap];
}

#pragma mark - Public Methods

- (void)showWithParentViewController:(UIViewController *)parentVC {
    [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    
    
    //[self setModalPresentationStyle:UIModalPresentationCustom];
    [parentVC presentViewController:self animated:YES completion:nil];
}

#pragma mark - Private Methods

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    if(!CGRectContainsPoint(_alertView.frame, location)){
        [self hide];
    }
}

- (void)hideWithCompletion:(void (^)(void))completion {
    [self dismissViewControllerAnimated:YES completion:completion];
}

-(void) hide{
    [self hideWithCompletion:nil];
}

#pragma mark - Actions

- (IBAction)didPressFirstButton:(id)sender {
    [self hideWithCompletion:^{
        self.firstButtonBlock();
    }];
}

- (IBAction)didPressSecondButton:(id)sender {
    [self hideWithCompletion:^{
        self.secondButtonBlock();
    }];
}



@end
