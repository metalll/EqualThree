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

    rankList = [NSArray new];
    
    self.navigationItem.title = @"High Score";
    
    self.navigationController.navigationBar.translucent = NO;
    
   
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setBarTintColor:[UIColor navigationBackgroundColor]];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [bar setTintColor:[UIColor whiteColor]];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.alpha=0.0f;
    
    
    
    [NSDPlistController loadPlistWithName:rankListName andCompletion:^(NSArray * arr){
        rankList=arr;
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
    tempCell.nameLabel.text = [NSString stringWithFormat:@" %li. %@  ", (long)indexPath.row+1,[[rankList objectAtIndex:indexPath.row] objectAtIndex:0]]  ;
    tempCell.scopeLabel.text = [[rankList objectAtIndex:indexPath.row] objectAtIndex:1];
    return tempCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return rankList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" Name                                     Score ";
}




@end
