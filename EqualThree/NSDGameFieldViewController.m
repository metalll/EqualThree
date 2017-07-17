//
//  NSDGameFieldViewController.m
//  EqualThree
//
//  Created by NSD on 14.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGameFieldViewController.h"
#import "NSDGameItemView.h"
@interface NSDGameFieldViewController ()
@property (weak, nonatomic) IBOutlet UIView *gameItemsField;

@end

@implementation NSDGameFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    NSUInteger fieldHeight = 10;
    NSUInteger fieldWidth = 10;
    
    CGFloat margin = 5;
    
    CGFloat containerHeight = self.gameItemsField.frame.size.height;
    
    CGFloat containerWidth = self.gameItemsField.frame.size.width;
    
    
    CGFloat itemWidth = (containerWidth/(CGFloat)fieldWidth);
    
    CGFloat itemHeight = (containerHeight/(CGFloat)fieldHeight);
    
    for(NSUInteger i = 0;i< fieldHeight;i++){
        for(NSUInteger j=0;j<fieldWidth;j++){
        
          
            CGFloat itemX = i * itemWidth;
            CGFloat itemY = j * itemHeight;
            
            CGRect itemFrame = CGRectMake(itemX+margin, itemY + margin, itemWidth-margin*2, itemHeight-margin*2);
            
              NSDGameItemView * itemViewView = [[NSDGameItemView alloc] initWithFrame:itemFrame];
            
            [itemViewView setBackgroundColor:[UIColor blueColor]];
            
            
        
            
            
            
            
            [self.gameItemsField addSubview:itemViewView];
            
        }
    }
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
