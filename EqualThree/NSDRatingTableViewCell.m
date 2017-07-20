//
//  NSDRatingTableViewCell.m
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDRatingTableViewCell.h"
#import "UIColor+NSDColor.h"
@implementation NSDRatingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setRatingRecordWithRecord:(NSDScoreRecord *)record andNumber:(NSUInteger) number{
    
    switch (number) {
        case 0:
            self.numberLabel.textColor = [UIColor goldColor];
            self.nameLabel.textColor = [UIColor goldColor];
            self.scopeLabel.textColor =[UIColor goldColor];
            break;
        case 1:
            self.numberLabel.textColor = [UIColor silverColor];
            self.nameLabel.textColor = [UIColor silverColor];
            self.scopeLabel.textColor =[UIColor silverColor];
            break;
        case 2:
            self.numberLabel.textColor = [UIColor bronzeColor];
            self.nameLabel.textColor = [UIColor bronzeColor];
            self.scopeLabel.textColor =[UIColor bronzeColor];
            break;
        default:
            self.numberLabel.textColor = [UIColor blackColor];
            self.nameLabel.textColor = [UIColor blackColor];
            self.scopeLabel.textColor =[UIColor blackColor];
            ;
    }
    
    self.numberLabel.text = [[NSString stringWithFormat:@"%li",(unsigned long)(NSUInteger)(number+1)] stringByAppendingString:@"."];
    self.nameLabel.text = record.userName;
    self.scopeLabel.text = [NSString stringWithFormat:@"%li", (unsigned long)record.userScore];

}




@end
