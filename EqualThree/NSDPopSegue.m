//
//  NSDPopSegue.m
//  EqualThree
//
//  Created by NSD on 10.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDPopSegue.h"

@implementation NSDPopSegue

- (void)perform{
    
    [self.sourceViewController.navigationController popViewControllerAnimated:YES];
}
@end
