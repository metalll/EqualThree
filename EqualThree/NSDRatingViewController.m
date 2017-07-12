//
//  NSDRatingViewController.m
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDRatingViewController.h"
#import "UIColor+NSDColor.h"
#import "NSDToastView.h"
#import "NSDPlistController.h"
#import "NSDRatingTableViewCell.h"
#import "NSDCustomHeaderForTableView.h"
#import "NSDScoreRecord.h"
#import "NSDHighscoresManager.h"
#define rankListName @"rankList.plist"

@interface NSDRatingViewController (){
    NSArray * rankList;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation NSDRatingViewController


#pragma mark - VC life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"High Score";
    
    self.navigationController.navigationBar.translucent = NO;
    
   
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setBarTintColor:[UIColor navigationBackgroundColor]];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [bar setTintColor:[UIColor whiteColor]];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.alpha=0.0f;
    
    
    
    
    
    
    
    
    
    [[NSDHighscoresManager sharedManager] allRecordsWithCompletion:^(NSArray * tArr) {
        rankList=tArr;
        [_tableView reloadData];
        [_activityIndicator stopAnimating];
        [UITableView animateWithDuration:.2 animations:^{
            _tableView.alpha=1.0f;
        }];
        

    }];

    
    
    
    
    
    
}


#pragma mark - table delegate impl

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDRatingTableViewCell * tempCell = [tableView dequeueReusableCellWithIdentifier:@"RatingTableViewCell"] ;
    if(!tempCell){
        [tableView registerNib:[UINib nibWithNibName:@"NSDRatingTableViewCell" bundle:nil] forCellReuseIdentifier:@"RatingTableViewCell"];
        tempCell = [tableView dequeueReusableCellWithIdentifier:@"RatingTableViewCell"] ;
    }
    
    [tempCell setRatingRecordWithRecord:[rankList objectAtIndex:indexPath.row] andNumber:indexPath.row];
    
    return tempCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return rankList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[[NSBundle mainBundle] loadNibNamed:@"NSDCustomViewForHeader" owner:self options:nil]firstObject];
    
    
}







@end
