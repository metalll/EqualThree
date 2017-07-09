//
//  NSDGameTableViewCell.h
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDGridGameView.h"

@interface NSDGameTableViewCell : UITableViewCell

@property(nonatomic) int height;
@property (weak, nonatomic) IBOutlet NSDGridGameView *gameGridView;

@end
