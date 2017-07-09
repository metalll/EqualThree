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
@interface NSDEqualThreeGameViewController (){
    int topTableViewCellHeight;
    int bottomTableViewCellHeight;
    int gameTableViewCellHeight;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NSDEqualThreeGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.alwaysBounceVertical = NO;
    
    gameTableViewCellHeight = self.view.frame.size.width;
    topTableViewCellHeight = (self.view.frame.size.height - self.view.frame.size.width)/2;
    bottomTableViewCellHeight = topTableViewCellHeight;
    
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = gameTableViewCellHeight;
    
    
    
    
    
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
        
        [bottomCell.helpButton addTarget:self action:@selector(didTouchUpInsideMenuButton) forControlEvents:UIControlEventTouchUpInside];
        
        
        return bottomCell;
    }
    
    
    return NULL;
    
}


-(void) didTouchUpInsideMenuButton{

    UIStoryboard * __weak storyboard = [self storyboard];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"MenuPopover"];
    
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.delegate = self;
    
    
}

-(void) didTouchUpInsideHelpButton{

}




@end
