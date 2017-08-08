//
//  NSDRatingViewController.m
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDHighscoreViewController.h"
#import "UIColor+NSDColor.h"
#import "NSDPlistController.h"
#import "NSDScoreTableViewCell.h"

#import "NSDScoreRecord.h"
#import "NSDHighscoresManager.h"


@interface NSDPopSegue : UIStoryboardSegue

@end


@implementation NSDPopSegue

- (void)perform{
    
    [self.sourceViewController.navigationController popViewControllerAnimated:YES];
}
@end


@interface NSDHighscoreViewController (){
    NSArray *_highscores;
}


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *placeholderView;

@end

@implementation  NSDHighscoreViewController


#pragma mark - Life Cycle

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"High Score";
    self.navigationController.navigationBar.translucent = NO;
    
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setBarTintColor:[UIColor navigationBackgroundColor]];
    [bar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Noteworthy-Bold" size:20.0f],
                                  NSForegroundColorAttributeName : [UIColor navigationForegroundColor]}];
    [bar setTintColor:[UIColor whiteColor]];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.alpha=0.0f;
    
    [[NSDHighscoresManager sharedManager] sortedElementsWithCompletion:^(NSArray *tArr) {
        _highscores = tArr;
        
        [self.activityIndicator stopAnimating];
        
        if(_highscores != nil && _highscores.count > 0){
            [self.tableView reloadData];
            [UITableView animateWithDuration:.2 animations:^{
                self.tableView.alpha=1.0f;
            }];
        }else{
            [UIView animateWithDuration:.2 animations:^{
                self.placeholderView.alpha=1.0f;
            }];
        }
    }];
    
    
}

#pragma mark - TableView delegate and data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDScoreTableViewCell *tempCell = [tableView dequeueReusableCellWithIdentifier:@"NSDScoreTableViewCell"];
    if(!tempCell){
        
        [tableView registerNib:[UINib nibWithNibName:@"NSDScoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"NSDScoreTableViewCell"];
        tempCell = [tableView dequeueReusableCellWithIdentifier:@"NSDScoreTableViewCell"];
    }
    
    [tempCell setScoreRecordWithScoreRecord:[_highscores objectAtIndex:indexPath.row] andNumber:indexPath.row];
    
    return tempCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _highscores.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[[NSBundle mainBundle] loadNibNamed:@"NSDCustomViewForHeader" owner:self options:nil]firstObject];
}

@end
