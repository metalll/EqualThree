//
//  NSDGameTableViewCell.m
//  EqualThree
//
//  Created by NSD on 09.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGameTableViewCell.h"

@implementation NSDGameTableViewCell


#pragma mark - basic init method

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


#pragma mark - overrideCellHeightGetter

-(int)height{
    return _height;
}

@end
