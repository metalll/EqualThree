//
//  NSDRatingViewController.m
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDHighscoreViewController.h"
#import "UIColor+NSDColor.h"
#import "NSDToastView.h"
#import "NSDPlistController.h"
#import "NSDRatingTableViewCell.h"
#import "NSDCustomHeaderForTableView.h"
#import "NSDScoreRecord.h"
#import "NSDHighscoresManager.h"
#define rankListName @"rankList.plist"

@interface NSDHighscoreViewController (){
    NSArray * rankList;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation  NSDHighscoreViewController


#pragma mark - VC life cycle

- (void)viewDidLoad {
    
    self.navigationItem.title = @"High Score";
    self.navigationController.navigationBar.translucent = NO;
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setBarTintColor:[UIColor navigationBackgroundColor]];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [bar setTintColor:[UIColor whiteColor]];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.alpha=0.0f;
    
    [[NSDHighscoresManager sharedManager] allRecordsWithCompletion:^(NSArray * tArr) {
        rankList=tArr;
        [self.tableView reloadData];
        [self.activityIndicator stopAnimating];
        [UITableView animateWithDuration:.2 animations:^{
            self.tableView.alpha=1.0f;
        }];
    }];
    
    [super viewDidLoad];
}

#pragma mark - TableView delegate and data source

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
