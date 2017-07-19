//
//  NSDGameFieldViewController.m
//  EqualThree
//
//  Created by NSD on 14.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGameFieldViewController.h"
#import "NSDGameItemView.h"
#import "NSDGame.h"



@interface NSDGameFieldViewController ()
@property (weak, nonatomic) IBOutlet UIView *gameItemsField;

- (void) subscribeToNotifications;
- (void) unsubscribeToNotifications;









@end


@implementation NSDGameFieldViewController





- (void)viewDidLoad {

    
    
    [super viewDidLoad];
    
    
    
    NSUInteger fieldHeight = 8;
    NSUInteger fieldWidth = 8;
    
    CGFloat margin = 2;
    
    CGFloat containerHeight = self.gameItemsField.frame.size.height;
    
    CGFloat containerWidth = self.gameItemsField.frame.size.width;
    
    
    CGFloat itemWidth = (containerWidth/(CGFloat)fieldWidth);
    
    CGFloat itemHeight = (containerHeight/(CGFloat)fieldHeight);
    
    for(NSUInteger i = 0;i< fieldHeight;i++){
        for(NSUInteger j=0;j<fieldWidth;j++){
        
          
            CGFloat itemX = i * itemWidth;
            CGFloat itemY = j * itemHeight;
            
            CGRect itemFrame = CGRectMake(itemX+margin, itemY + margin, itemWidth-margin*(float)2.0f, itemHeight-margin*(float)2.0f);
            
              NSDGameItemView * itemViewView = [[NSDGameItemView alloc] initWithFrame:itemFrame];
            
            [itemViewView setBackgroundColor:[UIColor blueColor]];
            
            
        
            
            
            
            
            [self.gameItemsField addSubview:itemViewView];
            
        }
    }
    
    
    
    
    [self subscribeToNotifications];
    
    // Do any additional setup after loading the view.
}


-(void)dealloc{
    [self unsubscribeToNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Notifications

- (void) subscribeToNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processItemsDidMoveNotifications) name:NSDGameItemsDidMoveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processItemsDidMoveNotifications) name:NSDGameItemsDidDeleteNotification object:nil];
    

}


- (void) processItemsDidMoveNotifications{

}


- (void) processItemsDidRemoveNotifications{
    
}




- (void) unsubscribeToNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
