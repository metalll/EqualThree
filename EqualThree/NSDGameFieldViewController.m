#import "NSDGameFieldViewController.h"
#import "NSDGameItemView.h"
#import "NSDGameEngine.h"
#import "NSDGameItemTransition.h"

@interface NSDGameFieldViewController ()

@property (weak, nonatomic) IBOutlet UIView *gameItemsView;
@property (strong, nonatomic) NSDGameEngine *gameEngine;
@property (strong, nonatomic) NSMutableArray *gameField;




@property NSUInteger horizontalItemsCount;
@property NSUInteger verticalItemsCount;
@property NSUInteger itemTypesCount;
@property CGSize itemSize;

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
    
    
    [self subscribeToNotifications];
    [self configureGame];
    [self initGestureRecognizerWithView:_gameItemsView];
    
    
    
    
    
}





- (void)dealloc {
    [self unsubscribeFromNotifications];
}

#pragma mark - Private Methods

- (void)configureGame {
    
    self.horizontalItemsCount = 8;
    self.verticalItemsCount = 8;
    self.itemTypesCount = 5;
    
    self.itemSize = CGSizeMake(self.gameItemsView.frame.size.width / self.horizontalItemsCount,
                               self.gameItemsView.frame.size.height / self.verticalItemsCount);
    
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
    
    itemView.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleBottomMargin;
    
    itemView.translatesAutoresizingMaskIntoConstraints = YES;
    itemView.type = type;
    
    [self.gameItemsView addSubview:itemView];
    
    return itemView;
}


- (CGPoint)xyCoordinatesFromI:(NSInteger)i j:(NSInteger)j {
    CGPoint result = CGPointMake(i * self.itemSize.width, j * self.itemSize.height);
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
    
    [self.gameItemsView addGestureRecognizer:swipeUp];
    [self.gameItemsView addGestureRecognizer:swipeDown];
    [self.gameItemsView addGestureRecognizer:swipeLeft];
    [self.gameItemsView addGestureRecognizer:swipeRight];
    
    
    
    
    
    
    
}


- (void) didSwipe:(UISwipeGestureRecognizer *) recognizer{
    
    CGPoint point = [recognizer locationInView: self.gameItemsView];
    
    
    
    NSUInteger x0 = 0;
    NSUInteger y0 = 0;
    
    
    NSDGameItemView * view0 = nil;
    NSDGameItemView * view1 = nil;
    
    
    
    //calculate x0;
    //calculate y0;
    
    for(NSUInteger i=0;i<self.verticalItemsCount;i++){
        for(NSUInteger j=0;j<self.horizontalItemsCount;j++){
            
            NSUInteger tempType =  [[[_gameEngine.gameField objectAtIndex:i] objectAtIndex:j] unsignedIntegerValue];
            
            
            
            NSDGameItemView * tempGameItemView = [self gameItemViewAtI:i j:j type: tempType ] ;
            if(CGRectContainsPoint( tempGameItemView.frame , point)){
                x0 = i;
                y0 = j;
                view0 = tempGameItemView;
                break;
            }
        }
    }
    
    
    
    
    if(recognizer.direction== UISwipeGestureRecognizerDirectionUp){
        
        if(view0!=nil){
            
            view1 = [self gameItemViewAtI:x0 j:y0-1 type:[_gameEngine.gameField[x0][y0-1]unsignedIntegerValue]];
            
        }
        
        
        view1.alpha = 0.0f;
        view0.alpha = 1.0f;
        
        CGRect frame0 = view0.frame;
        CGRect frame1 = view1.frame;
        
        
        
        
        [_gameEngine swapItemAtX0:x0 y0:y0 withItemAtX1:x0 y1:y0-1];
        
        
        
        [UIView animateWithDuration:0.2 animations:^{
            
            
            view0.frame = frame1;
            view0.alpha = 1.0f;
            
            
            
        }];
        [UIView animateWithDuration:0.1 animations:^{
            view1.frame = frame0;
            
            
        }completion:^(BOOL finished) {
            view1.alpha = 1.0f;
            
            
        }];
        
        
        
        return;
    }
    
    if(recognizer.direction== UISwipeGestureRecognizerDirectionDown){
        
        if(view0!=nil){
            
            view1 = [self gameItemViewAtI:x0 j:y0+1 type:[_gameEngine.gameField[x0][y0+1]unsignedIntegerValue]];
            
            
            
        }
        
        
        view1.alpha = 0.0f;
        view0.alpha = 1.0f;
        
        CGRect frame0 = view0.frame;
        CGRect frame1 = view1.frame;
        
        [_gameEngine swapItemAtX0:x0 y0:y0 withItemAtX1:x0 y1:y0+1];
        
        [UIView animateWithDuration:0.2 animations:^{
            view0.frame = frame1;
            view0.alpha = 1.0f;
            
        }];
        
        [UIView animateWithDuration:0.1 animations:^{
            view1.frame = frame0;
            
        }completion:^(BOOL finished) {
            view1.alpha = 1.0f;
            
        }];
        return;
    }
    
    
    
    
    
    if(recognizer.direction== UISwipeGestureRecognizerDirectionLeft){
        
        if(view0!=nil){
            
            view1 = [self gameItemViewAtI:x0-1 j:y0 type:[_gameEngine.gameField[x0-1][y0]unsignedIntegerValue]];
            
            
            
        }
        
        
        view1.alpha = 0.0f;
        view0.alpha = 1.0f;
        
        CGRect frame0 = view0.frame;
        CGRect frame1 = view1.frame;
        
        
        
        
        [_gameEngine swapItemAtX0:x0 y0:y0 withItemAtX1:x0-1 y1:y0];
        
        
        
        [UIView animateWithDuration:0.2 animations:^{
            
            
            view0.frame = frame1;
            view0.alpha = 1.0f;
            
            
            
        }];
        
        
        
        [UIView animateWithDuration:0.1 animations:^{
            view1.frame = frame0;
            
            
        }completion:^(BOOL finished) {
            view1.alpha = 1.0f;
            
            
        }];
        return;
    }
    
    
    
    if(recognizer.direction== UISwipeGestureRecognizerDirectionRight){
        
        if(view0!=nil){
            
            view1 = [self gameItemViewAtI:x0+1 j:y0 type:[_gameEngine.gameField[x0+1][y0]unsignedIntegerValue]];
            
            
            
        }
        
        
        view1.alpha = 0.0f;
        view0.alpha = 1.0f;
        
        CGRect frame0 = view0.frame;
        CGRect frame1 = view1.frame;
        
        
        
        
        [_gameEngine swapItemAtX0:x0 y0:y0 withItemAtX1:x0+1 y1:y0];
        
        
        
        [UIView animateWithDuration:0.2 animations:^{
            
            
            view1.frame = frame0;
            view1.alpha = 1.0f;
            
            
            
        }];
        
        
        
        [UIView animateWithDuration:0.1 animations:^{
            view0.frame = frame1;
             view0.alpha = 1.0f;
            
        }completion:^(BOOL finished) {
         //   view1.alpha = 1.0f;
            
            
        }];
        return;
    }
    
    
    
    //calculate x0;
    
    //calculate y0;
    
    
    
    
    
    
    
    
    
    
    
    
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
    
    NSArray *itemTransitions = notification.userInfo[kNSDGameItemTransitions];
    
    for (NSDGameItemTransition *itemTransition in itemTransitions) {
        
        NSDGameItemView *gameItemView = [self gameItemViewAtI:itemTransition.x0 j:itemTransition.y0 type:itemTransition.type];
        
        CGRect endFrame = CGRectZero;
        endFrame.size = gameItemView.frame.size;
        endFrame.origin = [self xyCoordinatesFromI:itemTransition.x1 j:itemTransition.y1];
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        [UIView animateWithDuration:6 animations:^{
            gameItemView.frame = endFrame;
            
            
            
            
        } completion:^(BOOL finished) {
            if(finished){
                
                
                
            }
            
            
        }];
    }
}









- (void)processItemsDidDeleteNotification:(NSNotification *)notification {
    
    
    
    
    
    
}




@end

