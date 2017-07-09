//
//  NSDGameBottomTableViewCell.h
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDGameBottomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property(nonatomic) int height;
@end
