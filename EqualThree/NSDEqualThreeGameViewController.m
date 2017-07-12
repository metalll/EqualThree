//
//  NSDEqualThreeGameViewController.m
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDEqualThreeGameViewController.h"
#import "NSDGameTableViewCell.h"
#import "NSDGameTopTableViewCell.h"
#import "NSDGameBottomTableViewCell.h"
#import "NSDRatingViewController.h"
#import "NSDMenuView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDGeneralMenuViewController.h"
#import "NSDToastView.h"
#import "UIColor+NSDColor.h"


@interface NSDEqualThreeGameViewController (){
    int topTableViewCellHeight;
    int bottomTableViewCellHeight;
    int gameTableViewCellHeight;
    NSDMenuView * menuView;
    NSDToastView * toast;
    
    CGRect menuButtonRectangle;

}
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NSDEqualThreeGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    menuView = NULL;
    
    _tableView.alwaysBounceVertical = NO;
    
    gameTableViewCellHeight = self.view.frame.size.width;
    topTableViewCellHeight = (self.view.frame.size.height - self.view.frame.size.width)/2;
    bottomTableViewCellHeight = topTableViewCellHeight;
    
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = gameTableViewCellHeight;
    
    toast = [NSDToastView new];
    
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:isHasSavedGame] isEqual:@YES ]){
     
        [toast displayOnView:_mainView withMessage:@"Resume game" andColor:[UIColor toastSimpleColor] andIndicator:NO andFaded:YES andIsHasTopBar:NO];
        
        
    
    }else{
    
        [toast displayOnView:_mainView withMessage:@"New game" andColor:[UIColor toastAcceptColor] andIndicator:NO andFaded:YES andIsHasTopBar:NO];
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:isHasSavedGame];
        
    
    }
    
    
    
    
    
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.row == 0){
        return topTableViewCellHeight;
    }
    if(indexPath.row == 1){
        return gameTableViewCellHeight;
    }
    if(indexPath.row == 2){
        return bottomTableViewCellHeight;
    }
    return 0;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{return 1;}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{return 3;}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    if(indexPath.row == 0){
    
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NSDGameTopTableViewCell" owner:self options:nil];
        
        NSDGameTopTableViewCell * topCell = (NSDGameTopTableViewCell *) [nib objectAtIndex:0];
        topCell.height = topTableViewCellHeight;
        
        
        return topCell;
    }
   
    if(indexPath.row == 1){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NSDGameTableViewCell" owner:self options:nil];
        
        NSDGameTableViewCell * gameCell = (NSDGameTableViewCell *) [nib objectAtIndex:0];
        
        gameCell.height = gameTableViewCellHeight;
        
        return gameCell;
    }
    
    
    if(indexPath.row == 2){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NSDGameBottomTableViewCell" owner:self options:nil];
        
        NSDGameBottomTableViewCell * bottomCell = (NSDGameBottomTableViewCell *) [nib objectAtIndex:0];
        
        bottomCell.height = bottomTableViewCellHeight;
        [bottomCell.menuButton addTarget:self action:@selector(didTouchUpInsideMenuButton) forControlEvents:UIControlEventTouchUpInside];
        
        [bottomCell.helpButton addTarget:self action:@selector(didTouchUpInsideHelpButton) forControlEvents:UIControlEventTouchUpInside];
        
        
        menuButtonRectangle = bottomCell.menuButton.frame;
        
        return bottomCell;
    }
    
    
    return NULL;
    
}


-(void) didTouchUpInsideMenuButton{
    
    
    int popoverMenuWidth = self.view.frame.size.width - 50;
    
    int popoverMenuY = self.view.frame.size.height - 110;
    
    

    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NSDMenuView" owner:self options:nil];
    
    menuView = (NSDMenuView *) [nib firstObject];
    
    menuView.frame = CGRectMake(25 , popoverMenuY , popoverMenuWidth, 100);

    [menuView.resumeButton addTarget:self action:@selector(didTouchUpInsideResumeButton) forControlEvents:UIControlEventTouchUpInside];
    [menuView.ExitButton addTarget:self action:@selector(didTouchUpInsideExitButton) forControlEvents:UIControlEventTouchUpInside];
    

    
    menuView.alpha = 0.0;
    menuView.layer.cornerRadius = 5;
    menuView.layer.borderWidth = 1.5f;
    menuView.layer.masksToBounds = YES;
    
    [self.view addSubview:menuView];
    
    [UIView animateWithDuration:0.4 animations:^{
        [menuView setAlpha:1.0];
    } completion:^(BOOL finished) {}];
 
}

-(void) didTouchUpInsideResumeButton{
    
    [UIView animateWithDuration:0.4 animations:^{
    
        
        [menuView setAlpha:0.0];
        
        
        
    } completion:^(BOOL finished) {
        if(finished){
        
            [menuView removeFromSuperview];
            
            menuView = NULL;
        
        }
    }];
    
    
    
}

-(void) didTouchUpInsideExitButton{
    
    
    //TODO for test
    

    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}



-(void) didTouchUpInsideHelpButton{

}





@end
