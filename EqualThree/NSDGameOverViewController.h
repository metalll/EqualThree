//
//  NSDGameOverViewController.h
//  EqualThree
//
//  Created by NSD on 05.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDGameOverViewController : UIViewController

@property (strong,nonatomic) NSString * movesText;
@property (strong,nonatomic) NSString * scoreText;



@property (weak, nonatomic) IBOutlet UILabel *movesLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end
