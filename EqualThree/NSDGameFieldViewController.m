#import "NSDGameFieldViewController.h"
#import "NSDGameItemView.h"
#import "NSDGameEngine.h"
#import "NSDGameItemTransition.h"
#include "NSDIJStruct.h"
@interface NSDGameFieldViewController ()

@property (weak, nonatomic) IBOutlet UIView *gameItemsView;
@property (strong, nonatomic) NSDGameEngine *gameEngine;
@property (strong, nonatomic) NSMutableArray *gameField;




@property NSUInteger horizontalItemsCount;
@property NSUInteger verticalItemsCount;
@property NSUInteger itemTypesCount;
@property CGSize itemSize;

@property BOOL isAnimatedField;

- (void)configureGame;
- (CGPoint)xyCoordinatesFromI:(NSInteger)i j:(NSInteger)j;
- (NSDGameItemView*)createGameItemViewWithFrame:(CGRect)frame type:(NSUInteger)type;
- (NSDGameItemView*)gameItemViewAtI:(NSInteger)i j:(NSInteger)j type:(NSUInteger)type;

- (void) didSwipe:(UISwipeGestureRecognizer *) recognizer;


- (void)subscribeToNotifications;
- (void)unsubscribeFromNotifications;

@end

@implementation NSDGameFieldViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @synchronized (self) {
        self.isAnimatedField = YES;
    }
    
    
    [self subscribeToNotifications];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self configureGame];
        [self initGestureRecognizerWithView:self.gameItemsView];

    });
    
   }

- (void)dealloc {
    [self unsubscribeFromNotifications];
}

#pragma mark - Private Methods

- (void)configureGame {
    
    self.horizontalItemsCount = 8;
    self.verticalItemsCount = 8;
    self.itemTypesCount = 5;
    
    self.itemSize = CGSizeMake(self.gameItemsView.frame.size.width / (CGFloat) self.horizontalItemsCount,
                               self.gameItemsView.frame.size.height / (CGFloat) self.verticalItemsCount);
    
    self.gameField = [NSMutableArray arrayWithCapacity:self.horizontalItemsCount];
    
    for (NSUInteger i = 0; i < self.horizontalItemsCount; i++) {
        NSMutableArray *column = [NSMutableArray arrayWithCapacity:self.verticalItemsCount];
        for (NSUInteger j = 0; j < self.verticalItemsCount; j++) {
            [column addObject:[NSNull null]];
        }
        [self.gameField addObject:column];
    }
    
    self.gameEngine = [[NSDGameEngine alloc] initWithHorizontalItemsCount:self.horizontalItemsCount
                                                       verticalItemsCount:self.verticalItemsCount
                                                           itemTypesCount:self.itemTypesCount];
}

- (NSDGameItemView*)createGameItemViewWithFrame:(CGRect)frame type:(NSUInteger)type{
    NSDGameItemView *itemView = [[NSDGameItemView alloc] initWithFrame:frame];
    
    itemView.type = type;
    
    [self.gameItemsView addSubview:itemView];
    
    return itemView;
}


- (CGPoint)xyCoordinatesFromI:(NSInteger)i j:(NSInteger)j {
    CGPoint result = CGPointMake(i * (CGFloat) self.itemSize.width, j * (CGFloat) self.itemSize.height);
    return result;
}

- (NSDGameItemView*)gameItemViewAtI:(NSInteger)i j:(NSInteger)j type:(NSUInteger)type{
    NSDGameItemView *result = nil;
    
    if ((i >= 0) && (i < self.horizontalItemsCount) && (j >= 0) && (j < self.verticalItemsCount)) {
        result = self.gameField[i][j];
    }
    
    if ((result == nil) || (result == (NSDGameItemView*)[NSNull null])) {
        CGRect frame = CGRectZero;
        frame.origin = [self xyCoordinatesFromI:i j:j];
        frame.size = self.itemSize;
        result = [self createGameItemViewWithFrame:frame type:type];
    }
    
    return result;
}



#pragma mark - Gesture Recognizer


- (void) initGestureRecognizerWithView:(UIView *) view {
    
    UISwipeGestureRecognizer * swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    UISwipeGestureRecognizer * swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    UISwipeGestureRecognizer * swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer * swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    [view addGestureRecognizer:swipeUp];
    [view addGestureRecognizer:swipeDown];
    [view addGestureRecognizer:swipeLeft];
    [view addGestureRecognizer:swipeRight];
}



- (void) findIJPositionItemWithPoint:(CGPoint) swipePoint andCompletion:(void(^)(NSDIJStruct * result)) completion {
  
    NSOperationQueue * queue = [NSOperationQueue new];
    [queue setMaxConcurrentOperationCount:2];
    
    NSBlockOperation * firstPart = [NSBlockOperation blockOperationWithBlock:^{
        
        /*
         
         ****0
         ***00
         **000
         *0000
         00000
         
         */
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for(NSUInteger i=0;i<self.verticalItemsCount;i++){
                for(NSUInteger j=i;j<self.horizontalItemsCount;j++){
                    CGPoint tempPoint = [self xyCoordinatesFromI:i j:j];
                    CGRect tempRect = CGRectMake(tempPoint.x, tempPoint.y, self.itemSize.width, self.itemSize.height);
                    if(CGRectContainsPoint(tempRect, swipePoint)){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion([[NSDIJStruct alloc] initWithI:i andJ:j]);
                        });
                        [queue cancelAllOperations];
                    }
                }
            }

        });
        
        
      
        
    }];
    
    
    NSBlockOperation * secondPart = [NSBlockOperation blockOperationWithBlock:^{
          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    /*
       00000
       0000*
       000**
       00***
       0****
    */
              
        for(NSInteger j=0;j<self.horizontalItemsCount;j++){
            for(NSInteger i=(self.verticalItemsCount-1);i>j;i--){
                CGPoint tempPoint = [self xyCoordinatesFromI:i j:j];
                CGRect tempRect = CGRectMake(tempPoint.x, tempPoint.y, self.itemSize.width, self.itemSize.height);
                if(CGRectContainsPoint(tempRect, swipePoint)){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion([[NSDIJStruct alloc] initWithI:i andJ:j]);
                       
                    });
                    [queue cancelAllOperations];}
            }
        }
        
          });
    }];

    [queue addOperation:firstPart];
    [queue addOperation:secondPart];
    
                       
}


- (void) didSwipe:(UISwipeGestureRecognizer *) recognizer{
    
    if(recognizer.state != UIGestureRecognizerStateEnded || self.isAnimatedField ) return;
    
    [self findIJPositionItemWithPoint:[recognizer locationInView: self.gameItemsView] andCompletion:^(NSDIJStruct *result) {
        NSUInteger itemPosI = result.i;
        NSUInteger itemPosJ = result.j;
        
        
        
        switch (recognizer.direction) {
            case UISwipeGestureRecognizerDirectionUp:
                if(itemPosJ>0)
                    [self.gameEngine swapItemAtX0:itemPosI y0:itemPosJ withItemAtX1:itemPosI y1:itemPosJ-1];
                return;
                break;
                
            case UISwipeGestureRecognizerDirectionDown:
                if(itemPosJ<(self.verticalItemsCount-1))
                    [self.gameEngine swapItemAtX0:itemPosI y0:itemPosJ withItemAtX1:itemPosI y1:itemPosJ+1];
                return;
                break;
            case UISwipeGestureRecognizerDirectionLeft:
                if(itemPosI>0)
                    [self.gameEngine swapItemAtX0:itemPosI y0:itemPosJ withItemAtX1:itemPosI-1 y1:itemPosJ];
                return;
                break;
            case UISwipeGestureRecognizerDirectionRight:
                if(itemPosI<(self.horizontalItemsCount-1)){
                    [self.gameEngine swapItemAtX0:itemPosI y0:itemPosJ withItemAtX1:itemPosI+1 y1:itemPosJ];
                }
                break;
                return;
            default:
                return;
                break;
        }

    } ];
    
    
    
}


#pragma mark - Notifications

- (void)subscribeToNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processItemsDidMoveNotification:) name:NSDGameItemsDidMoveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processItemsDidMoveNotification:) name:NSDGameItemsDidDeleteNotification object:nil];
}

- (void)unsubscribeFromNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)processItemsDidMoveNotification:(NSNotification *)notification {
    
    
    @synchronized (self) {
        self.isAnimatedField = YES;
    }
    
    NSArray *itemTransitions = notification.userInfo[kNSDGameItemTransitions];
    
    for (NSUInteger i=0;i<itemTransitions.count;i++) {
        NSDGameItemTransition *itemTransition = itemTransitions[i];
        NSDGameItemView *gameItemView = [self gameItemViewAtI:itemTransition.x0 j:itemTransition.y0 type:itemTransition.type];
        
        CGRect endFrame = CGRectZero;
        endFrame.size = gameItemView.frame.size;
        
        CGFloat autoresizedMarginX = (self.itemSize.width - endFrame.size.width)/2.0f;
        CGFloat autoresizedMarginY = (self.itemSize.height - endFrame.size.height)/2.0f;
        
        CGPoint tempOriginPoint = [self xyCoordinatesFromI:(CGFloat)itemTransition.x1 j:(CGFloat)itemTransition.y1];
        endFrame.origin = CGPointMake( tempOriginPoint.x +autoresizedMarginX ,tempOriginPoint.y+autoresizedMarginY);
        
        
       
    
        
        [UIView animateWithDuration:0.44 animations:^{
            gameItemView.frame = endFrame;
        } completion:^(BOOL finished) {
            self.gameField[itemTransition.x1][itemTransition.y1] = gameItemView;
            if(finished&&(i==(itemTransitions.count-1))) {
            
                @synchronized (self) {
                    self.isAnimatedField = NO;
                }
            
            }
        }];
    }
    
}

- (void)processItemsDidDeleteNotification:(NSNotification *)notification {
 
    
    
    
    
    
    
}




@end

