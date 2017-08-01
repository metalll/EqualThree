#import "NSDGameFieldViewController.h"
#import "NSDGameItemView.h"
#import "NSDGameEngine.h"
#import "NSDGameItemTransition.h"
#import "NSDIJStruct.h"


NSString * const NSDGameDidFieldEndDeletig = @"NSDGameFieldDidFieldEndDeleting";

NSString * const kNSDCostDeletedItems = @"kNSDCostDeletedItems";
NSUInteger const NSDCostItem = 10;

@interface NSDGameFieldViewController ()

@property (weak, nonatomic) IBOutlet UIView *gameItemsView;
@property (strong, nonatomic) NSDGameEngine *gameEngine;
@property (strong, nonatomic) NSMutableArray *gameField;






@property NSUInteger horizontalItemsCount;
@property NSUInteger verticalItemsCount;
@property NSUInteger itemTypesCount;
@property CGSize itemSize;
@property (nonatomic)BOOL animated;

@property (strong) dispatch_queue_t animationQueue;

- (void)configureGame;
- (CGPoint)xyCoordinatesFromI:(NSInteger)i j:(NSInteger)j;
- (NSDGameItemView*)createGameItemViewWithFrame:(CGRect)frame type:(NSUInteger)type;
- (NSDGameItemView*)gameItemViewAtI:(NSInteger)i j:(NSInteger)j type:(NSUInteger)type;

- (void) didRecognizePan:(UIPanGestureRecognizer *) recognizer;


- (void)subscribeToNotifications;
- (void)unsubscribeFromNotifications;

@end

@implementation NSDGameFieldViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.animationQueue = dispatch_queue_create("com.unique.name.queue", DISPATCH_QUEUE_SERIAL);
    [self subscribeToNotifications];
    
    
    [self initGestureRecognizerWithView:self.gameItemsView];
    
    
    
    
    
    
    
    
}



-(void)viewDidLayoutSubviews{
    
    if(self.gameEngine==nil){
        [self configureGame];
    }
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
    
    itemView.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleBottomMargin;
    
    itemView.translatesAutoresizingMaskIntoConstraints = YES;
    
    
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
    
    if (result == nil || (result == (NSDGameItemView*)[NSNull null])) {
        CGRect frame = CGRectZero;
        frame.origin = [self xyCoordinatesFromI:i j:j];
        frame.size = self.itemSize;
        result = [self createGameItemViewWithFrame:frame type:type];
    }
    
    return result;
}





#pragma mark - Gesture Recognizer


- (void) initGestureRecognizerWithView:(UIView *) view {
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizePan:)];
    
    [view addGestureRecognizer:pan];
    
}



- (NSDIJStruct *) iJPositionItemWithPoint:(CGPoint) point {
    
    NSDIJStruct * result = nil ;
    
    
    
    
    result =  [[NSDIJStruct alloc] initWithI:floor( (CGFloat) point.x/(CGFloat)self.itemSize.width) andJ: floor( (CGFloat) point.y / (CGFloat)self.itemSize.height)];
    
    return result;
}


- (void) didRecognizePan:(UISwipeGestureRecognizer *) recognizer{
    
    if(self.animated) return;
    
    static CGPoint startingLocation;
    static CGPoint currentLocation;
    static BOOL finished;
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            startingLocation = [recognizer locationInView:self.gameItemsView];
            currentLocation = startingLocation;
            finished = NO;
            break;
        case UIGestureRecognizerStateChanged:
            currentLocation = [recognizer locationInView:self.gameItemsView];
            break;
        default:
            return;
    }
    
    if (!finished ) {
        CGFloat deltaX = currentLocation.x - startingLocation.x;
        CGFloat deltaY = currentLocation.y - startingLocation.y;
        
        if ((fabs(deltaX) > (self.itemSize.width / 2)) || (fabs(deltaY) > (self.itemSize.height / 2))) {
            
            finished = YES;
            
            NSDIJStruct * ijstruct = [self iJPositionItemWithPoint:startingLocation];
            NSUInteger i = ijstruct.i;
            NSUInteger j = ijstruct.j;
            
            
            if (fabs(deltaX) > fabs(deltaY)) {
                if (deltaX > 0) {
                    if (i < (self.horizontalItemsCount - 1)) {
                        
                        [self.gameEngine swapItemsWithSwap:[[NSDSwap alloc] initSwapWithFrom:ijstruct to:[[NSDIJStruct alloc] initWithI:i+1 andJ:j]]];
                        
                    }
                } else {
                    if (i > 0) {
                        [self.gameEngine swapItemsWithSwap:[[NSDSwap alloc] initSwapWithFrom:ijstruct to:[[NSDIJStruct alloc] initWithI:i-1 andJ:j]]];
                    }
                }
            } else {
                if (deltaY > 0) {
                    if (j < (self.verticalItemsCount - 1)) {
                        [self.gameEngine swapItemsWithSwap:[[NSDSwap alloc] initSwapWithFrom:ijstruct to:[[NSDIJStruct alloc] initWithI:i andJ:j+1]]];
                    }
                } else {
                    if (j > 0) {
                        [self.gameEngine swapItemsWithSwap:[[NSDSwap alloc] initSwapWithFrom:ijstruct to:[[NSDIJStruct alloc] initWithI:i andJ:j-1]]];
                    }
                }
            }
        }
    }
    
}


#pragma mark - Notifications

- (void)subscribeToNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processItemsDidMoveNotification:) name:NSDGameItemsDidMoveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processItemsDidDeleteNotification:) name:NSDGameItemsDidDeleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processGotoAwaitStateNotification:) name:NSDEndOfTransitions object:nil];
    
    
}

- (void)unsubscribeFromNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




-(void)notifyAboutDidFieldEndDeletingWithScoreCount:(NSUInteger) scoreCount{
    
    
    NSNotification * notification = [NSNotification notificationWithName:NSDGameDidFieldEndDeletig
                                                                  object:nil
                                                                userInfo:@{
                                                                           kNSDCostDeletedItems : @(scoreCount)
                                                                           }];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
}

- (void)processItemsDidMoveNotification:(NSNotification *)notification {
    self.animated = YES;
    NSArray *itemTransitions = notification.userInfo[kNSDGameItemTransitions];
    
    dispatch_async(self.animationQueue, ^{
        
        dispatch_group_t animationGroup = dispatch_group_create();
        
        for (NSDGameItemTransition *itemTransition in itemTransitions) {
            
            dispatch_group_enter(animationGroup);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDGameItemView *gameItemView = [self gameItemViewAtI:itemTransition.from.i j:itemTransition.from.j type:itemTransition.type];
                CGRect endFrame = CGRectZero;
                endFrame.size = gameItemView.frame.size;
                endFrame.origin = [self xyCoordinatesFromI:itemTransition.to.i j:itemTransition.to.j];
                
                [UIView animateWithDuration:0.4 animations:^{
                    gameItemView.frame = endFrame;
                } completion:^(BOOL finished) {
                    self.gameField[itemTransition.to.i][itemTransition.to.j] = gameItemView;
                    dispatch_group_leave(animationGroup);
                }];
            });
        }
        dispatch_group_wait(animationGroup, DISPATCH_TIME_FOREVER);
    });
    
}



-(void)processGotoAwaitStateNotification:(NSNotification *)notification{
    
    dispatch_async(self.animationQueue, ^{
        
        dispatch_group_t animationGroup = dispatch_group_create();
        dispatch_group_enter(animationGroup);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.animated = NO;
            dispatch_group_leave(animationGroup);
            
        });
        
        
    });
    
    
    
}

- (void)processItemsDidDeleteNotification:(NSNotification *)notification {
    self.animated = YES;
    NSArray *itemsToDelete = notification.userInfo[kNSDGameItems];
    
    
    
    
    
    
    
    
    dispatch_async(self.animationQueue, ^{
        
        dispatch_group_t animationGroup = dispatch_group_create();
        
        
        for(NSDIJStruct * tempStruct in itemsToDelete){
            
            if(self.gameField[tempStruct.i][tempStruct.j]!=[NSNull null]){
                
                dispatch_group_enter(animationGroup);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    
                    
                    NSUInteger i = tempStruct.i;
                    NSUInteger j = tempStruct.j;
                    
                    [UIView animateWithDuration:0.2  animations:^{
                        [self.gameField[i][j] setAlpha:0.0];
                    } completion:^(BOOL finished) {
                        [self notifyAboutDidFieldEndDeletingWithScoreCount:NSDCostItem*itemsToDelete.count];

                        [self.gameField[i][j] removeFromSuperview];
                        self.gameField[i][j] = [NSNull null];
                        
                        
                        
                        
                        
                        dispatch_group_leave(animationGroup);
                        
                        
                        
                        
                        
                        
                    }];
                    
                    
                    
                });
                
            }
        }
        
        
        
        dispatch_group_wait(animationGroup, DISPATCH_TIME_FOREVER);
        
        
        
        
        
        
        
    });
}




@end

