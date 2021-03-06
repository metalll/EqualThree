//
//  NSDRatingTableViewCell.m
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDScoreTableViewCell.h"
#import "UIColor+NSDColor.h"

@implementation NSDScoreTableViewCell


-(void)awakeFromNib{

    [super awakeFromNib];
    
    UIImage * image = [UIImage imageNamed:@"Accessory"];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];

    
    self.accessoryView = imageView;
    
}

- (void)setScoreRecordWithScoreRecord:(NSDScoreRecord *)record andNumber:(NSUInteger) number{
    
    switch (number) {
            
        case 0:
            
            [self setBackgroundColor:[UIColor goldColor]];
            break;
            
        case 1:
            
            [self setBackgroundColor:[UIColor silverColor]];
            break;
            
        case 2:
            
            [self setBackgroundColor:[UIColor bronzeColor]];
            break;
            
        default:
            
            [self setBackgroundColor:[UIColor tableViewCellDefaultBackroundColor]];
            break;
    }
    
    self.numberLabel.text = [[NSString stringWithFormat:@"%li",(unsigned long)(NSUInteger)(number + 1)] stringByAppendingString:@"."];
    self.nameLabel.text = record.userName;
    self.scopeLabel.text = [record.userScore stringValue];
    
}

@end
