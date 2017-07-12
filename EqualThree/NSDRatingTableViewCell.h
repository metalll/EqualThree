//
//  NSDRatingTableViewCell.h
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDScoreRecord.h"
@interface NSDRatingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scopeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;


-(void)setRatingRecordWithRecord:(NSDScoreRecord *)record andNumber:(NSUInteger) number;



@end
