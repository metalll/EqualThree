//
//  NSDGameTopTableViewCell.h
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDGameTopTableViewCell : UITableViewCell
@property(nonatomic) int height;
@property (weak, nonatomic) IBOutlet UILabel *targetCount;
@property (weak, nonatomic) IBOutlet UILabel *MoviesCount;
@property (weak, nonatomic) IBOutlet UILabel *ScoreCount;

@end
