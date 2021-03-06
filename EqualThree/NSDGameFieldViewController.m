#import "NSDGameFieldViewController.h"
#import "NSDGameItemView.h"
#import "NSDGameEngine.h"
#import "NSDGameItemTransition.h"
#import "NSDIJStruct.h"
#import "NSDGameViewController.h"
#import "NSDGameSharedManager.h"
#import "NSDReplayRecorder.h"
#import "NSDReplayPlayer.h"

NSString * const NSDGameFieldDidEndDeletingNotification = @"NSDGameFieldDidFieldEndDeleting";
NSString * const kNSDDeletedItemsCost = @"kNSDCostDeletedItems";

NSString * const NSDUserHintItems = @"NSDUserHintItems";

NSString * const NSDGameFieldEndPlayingReplay = @"NSDGameFieldEndPlayingReplay";

NSUInteger const NSDItemCost = 10;
NSUInteger const NSDGameFieldWidth = 5;
NSUInteger const NSDGameFieldHeight = 5;



float const NSDDeleteAnimationDuration = 0.16f;

@interface NSDGameFieldViewController (){
    NSString * _replayUUID;
}

@property (weak, nonatomic) IBOutlet UIView *gameItemsView;
@property (strong, nonatomic) NSDGameEngine *gameEngine;
@property (strong, nonatomic) NSMutableArray *gameField;

@property NSArray *hint;
@property BOOL isUserHelpNeeded;
@property BOOL isUserRecivedHint;

@property NSUInteger horizontalItemsCount;
@property NSUInteger verticalItemsCount;
@property NSUInteger itemTypesCount;
@property CGSize itemSize;

@property (nonatomic)BOOL animated;

@property (strong) dispatch_queue_t animationQueue;

- (void)configureGame;
- (void)restoreLastSavedGame;
- (void)playReplay;

- (BOOL)shouldBeApplyRecivedNotification:(NSNotification *)notification;
- (NSDGameItemView *)createGameItemViewWithFrame:(CGRect)frame type:(NSUInteger)type;
- (CGPoint)xyCoordinatesFromIJStruct:(NSDIJStruct *) iJStruct;
- (NSDGameItemView*)gameItemViewAtIJStruct:(NSDIJStruct *)iJStruct type:(NSUInteger)type;
- (NSDIJStruct *) iJPositionItemWithPoint:(CGPoint) point;
- (void)hintUser;
- (void)removeUserHint;
- (void)initGestureRecognizerWithView:(UIView *)view;
- (void)didRecognizePan:(UIPanGestureRecognizer *)recognizer;

- (void)subscribeToNotifications;
- (void)unsubscribeFromNotifications;

- (void)notifyAboutGameFieldDidEndDeletingWithScoreCount:(NSUInteger)scoreCount;

- (void)processItemsDidMoveNotification:(NSNotification *)notification;
- (void)processGotoAwaitStateNotification:(NSNotification *)notification;
- (void)processDidFindPermissibleStroke:(NSNotification *)notification;
- (void)processItemsDidDeleteNotification:(NSNotification *)notification;

@end

@implementation NSDGameFieldViewController

#pragma mark - Life Cycle

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.isUserHelpNeeded = NO;
    self.hint = nil;
    self.isUserRecivedHint = NO;
    
    [self.gameItemsView setBackgroundColor:[UIColor clearColor]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.animationQueue = dispatch_queue_create("com.nsd.game.field.animation.queue", DISPATCH_QUEUE_SERIAL);
        [self subscribeToNotifications];
        
        [self initGestureRecognizerWithView:self.gameItemsView];
    });
}


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(),^{
        
        
        if(self.gameField.count>0){
            
            for(UIView * view in self.gameField){
                
                [view removeFromSuperview];
            }
        }
        
        
        if(self.isNewGame||self.isReplay){
            
            self.gameField = nil;
            
            if(self.isNewGame){
                
                self.isReplay = NO;
                [self configureGame];
            }else{
                self.isNewGame = NO;
                [self playReplay];
            }
        }
        else {
            
            self.isReplay = NO;
            self.isNewGame = NO;
            
            [self restoreLastSavedGame];
        }
    });
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [[NSDReplayRecorder sharedInstance] stopRecording];
    
    
}

- (void)dealloc{
    
    [self unsubscribeFromNotifications];
}

#pragma mark - Private Methods

- (BOOL)shouldBeApplyRecivedNotification:(NSNotification *)notification{
    
    return !(!self.isReplay&&[notification.object isKindOfClass:[NSDReplayPlayer class]])||(_isReplay&&![_replayUUID isEqual: [[NSDReplayPlayer sharedInstance] UUID]]);
    
}

- (void)restoreLastSavedGame{
    
    NSDGameSharedInstance *instance = [[NSDGameSharedManager sharedInstance] lastSavedGame];
    
    [[NSDReplayRecorder sharedInstance] restoreRecorder];
    
    self.horizontalItemsCount = instance.field.count;
    self.verticalItemsCount = ((NSMutableArray *)instance.field.firstObject).count;
    self.itemTypesCount = NSDGameItemTypesCount;
    
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
    
    self.gameEngine = [[NSDGameEngine alloc] initWithSharedInstance:instance];
}

- (void)configureGame{
    
    self.gameEngine = nil;
    [[NSDReplayRecorder sharedInstance] configureRecorder];
    self.horizontalItemsCount = NSDGameFieldWidth;
    self.verticalItemsCount = NSDGameFieldHeight;
    self.itemTypesCount = NSDGameItemTypesCount;
    
    
    
    self.isUserHelpNeeded = NO;
    self.isUserRecivedHint = NO;
    
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

- (void)playReplay{
    
    self.gameEngine = nil;
    
    self.isUserHelpNeeded = NO;
    self.isUserRecivedHint = NO;
    
    self.horizontalItemsCount = NSDGameFieldWidth;
    self.verticalItemsCount = NSDGameFieldHeight;
    self.itemTypesCount = NSDGameItemTypesCount;
    
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
    
    _replayUUID = [[NSUUID UUID] UUIDString];
    
    [[NSDReplayPlayer sharedInstance] playReplayWithID:self.replayID UUID:_replayUUID];
    
    
    
}

#pragma mark - Private

- (NSDGameItemView *)createGameItemViewWithFrame:(CGRect)frame type:(NSUInteger)type{
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


#pragma mark - Coordinate translation

- (CGPoint)xyCoordinatesFromIJStruct:(NSDIJStruct *)iJStruct{
    CGPoint result = CGPointMake(iJStruct.i * (CGFloat) self.itemSize.width, iJStruct.j * (CGFloat) self.itemSize.height);
    return result;
}

- (NSDGameItemView*)gameItemViewAtIJStruct:(NSDIJStruct *)iJStruct type:(NSUInteger)type{
    
    NSDGameItemView *result = nil;
    
    if ((iJStruct.i >= 0) && (iJStruct.i < self.horizontalItemsCount) && (iJStruct.j >= 0) && (iJStruct.j < self.verticalItemsCount)){
        
        result = self.gameField[iJStruct.i][iJStruct.j];
    }
    
    if (result == nil || (result == (NSDGameItemView*)[NSNull null])) {
        CGRect frame = CGRectZero;
        frame.origin = [self xyCoordinatesFromIJStruct:iJStruct];
        frame.size = self.itemSize;
        result = [self createGameItemViewWithFrame:frame type:type];
    }
    
    return result;
}

- (NSDIJStruct *)iJPositionItemWithPoint:(CGPoint)point{
    
    NSDIJStruct *result = nil ;
    
    result = [[NSDIJStruct alloc] initWithI:floor((CGFloat) point.x/(CGFloat)self.itemSize.width) andJ: floor( (CGFloat) point.y / (CGFloat)self.itemSize.height)];
    
    return result;
}




#pragma mark - Hint

- (void)hintUser{
    
    if(self.hint == nil){
        
        self.isUserHelpNeeded = YES;
        return;
    }
    
    if(self.animated&&!self.isReplay){
        
        return;
    }
    
    if(self.isUserRecivedHint){
        
        return;
    }
    
    self.isUserHelpNeeded = NO;
    
    for(NSUInteger i = 0; i < self.hint.count; i++){
        
        NSDIJStruct *item = self.hint[i];
        
        [((NSDGameItemView *)self.gameField[item.i][item.j]) setHighlighted:YES];
        
    }
    
    self.isUserRecivedHint = YES;
}


-(void)removeUserHint{
    
    if(!self.isUserRecivedHint){
        return;
    }
    
    for (NSUInteger i = 0; i < self.hint.count; i++) {
        
        NSDIJStruct *tempIJ = self.hint[i];
        
        [self.gameField[tempIJ.i][tempIJ.j] setHighlighted:NO];
    }
    
    self.isUserRecivedHint = NO;
}

#pragma mark - Gesture Recognizer

- (void)initGestureRecognizerWithView:(UIView *)view{
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizePan:)];
    
    [view addGestureRecognizer:pan];
}


- (void)didRecognizePan:(UISwipeGestureRecognizer *)recognizer{
    
    if(self.animated||self.isReplay){
        return;
    }
    
    [self removeUserHint];
    
    static CGPoint startingLocation;
    static CGPoint currentLocation;
    static BOOL finished;
    
    switch (recognizer.state){
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
    
    if (!finished){
        CGFloat deltaX = currentLocation.x - startingLocation.x;
        CGFloat deltaY = currentLocation.y - startingLocation.y;
        
        if ((fabs(deltaX) > (self.itemSize.width / 3.4f)) || (fabs(deltaY) > (self.itemSize.height / 3.4f))){
            
            finished = YES;
            
            NSDIJStruct * iJStruct = [self iJPositionItemWithPoint:startingLocation];
            
            NSUInteger i = iJStruct.i;
            NSUInteger j = iJStruct.j;
            
            if (fabs(deltaX) > fabs(deltaY)){
                if (deltaX > 0) {
                    if (i < (self.horizontalItemsCount - 1)) {
                        
                        [self.gameEngine swapItemsWithSwap:[[NSDSwap alloc] initSwapWithFrom:iJStruct to:[[NSDIJStruct alloc] initWithI:(i + 1) andJ:j]]];
                    }
                } else {
                    if (i > 0) {
                        
                        [self.gameEngine swapItemsWithSwap:[[NSDSwap alloc] initSwapWithFrom:iJStruct to:[[NSDIJStruct alloc] initWithI:(i - 1) andJ:j]]];
                    }
                }
            } else {
                if (deltaY > 0) {
                    
                    if (j < (self.verticalItemsCount - 1)) {
                        [self.gameEngine swapItemsWithSwap:[[NSDSwap alloc] initSwapWithFrom:iJStruct to:[[NSDIJStruct alloc] initWithI:i andJ:(j + 1)]]];
                    }
                } else {
                    if (j > 0) {
                        
                        [self.gameEngine swapItemsWithSwap:[[NSDSwap alloc] initSwapWithFrom:iJStruct to:[[NSDIJStruct alloc] initWithI:i andJ:(j - 1)]]];
                    }
                }
            }
        }
    }
}


#pragma mark - Notifications

- (void)subscribeToNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processItemsDidMoveNotification:) name:NSDGameItemsDidMoveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processItemsDidDeleteNotification:) name:NSDGameItemsDidDeleteNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processGotoAwaitStateNotification:) name:NSDDidGoToAwaitState object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processDidFindPermissibleStroke:) name:NSDDidFindPermissibleStroke object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hintUser) name:NSDUserDidTapHintButton object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processDidDetectEndPlayingReplay) name:NSDEndPlayReplay object:nil];
    
}


- (void)unsubscribeFromNotifications{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)notifyAboutGameFieldDidEndPlayingReplay{
    
    NSNotification *notification = [NSNotification notificationWithName:NSDGameFieldEndPlayingReplay
                                                                 object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)notifyAboutGameFieldDidEndDeletingWithScoreCount:(NSUInteger)scoreCount{
    
    NSNotification *notification = [NSNotification notificationWithName:NSDGameFieldDidEndDeletingNotification
                                                                 object:nil
                                                               userInfo:@{
                                                                          kNSDDeletedItemsCost : @(scoreCount)
                                                                          }];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)processItemsDidMoveNotification:(NSNotification *)notification{
    
    self.animated = YES;
    
    [self removeUserHint];
    
    NSArray *itemTransitions = notification.userInfo[kNSDGameItemTransitions];
    
    dispatch_async(self.animationQueue, ^{
        
        dispatch_group_t animationGroup = dispatch_group_create();
        
        for (NSDGameItemTransition *itemTransition in itemTransitions) {
            
            dispatch_group_enter(animationGroup);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if( ! [self shouldBeApplyRecivedNotification:notification]){
                    
                    dispatch_group_leave(animationGroup);
                }else{
                    NSDGameItemView *gameItemView = [self gameItemViewAtIJStruct:itemTransition.from type:itemTransition.type];
                    CGRect endFrame = CGRectZero;
                    endFrame.size = gameItemView.frame.size;
                    endFrame.origin = [self xyCoordinatesFromIJStruct:itemTransition.to];
                    
                    [UIView animateWithDuration:itemTransition.animationDuration animations:^{
                        gameItemView.frame = endFrame;
                    } completion:^(BOOL finished) {
                        self.gameField[itemTransition.to.i][itemTransition.to.j] = gameItemView;
                        dispatch_group_leave(animationGroup);
                    }];
                }
            });
        }
        
        dispatch_group_wait(animationGroup, DISPATCH_TIME_FOREVER);
    });
    
}

- (void)processGotoAwaitStateNotification:(NSNotification *)notification{
    
    dispatch_async(self.animationQueue, ^{
        
        dispatch_group_t animationGroup = dispatch_group_create();
        dispatch_group_enter(animationGroup);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if( ! [self shouldBeApplyRecivedNotification:notification]){
                dispatch_group_leave(animationGroup);
                
                
            }else{
                
                self.animated = NO;
                dispatch_group_leave(animationGroup);
                
            }
        });
        
        dispatch_group_wait(animationGroup, DISPATCH_TIME_FOREVER);
        
    });
}


- (void)processDidFindPermissibleStroke:(NSNotification *)notification{
    
    if(self.isReplay){
        
        dispatch_async(self.animationQueue, ^{
            
            dispatch_group_t animationGroup = dispatch_group_create();
            dispatch_group_enter(animationGroup);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                self.hint = notification.userInfo[kNSDGameItems];
                
                if( ! [self shouldBeApplyRecivedNotification:notification]){
                    
                }else{
                    
                    [self hintUser];
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    if( ! [self shouldBeApplyRecivedNotification:notification]){
                        
                    }else{
                        
                        [self removeUserHint];
                    }
                    dispatch_group_leave(animationGroup);
                });
                
            });
            
            dispatch_group_wait(animationGroup, DISPATCH_TIME_FOREVER);
        });
        
        
    }else{
        self.hint = notification.userInfo[kNSDGameItems];
        
        if(self.isUserHelpNeeded){
            [self hintUser];
        }
    }
}


- (void)processItemsDidDeleteNotification:(NSNotification *)notification{
    
    self.hint = nil;
    self.isUserHelpNeeded = NO;
    
    self.animated = YES;
    
    NSArray *itemsToDelete = notification.userInfo[kNSDGameItems];
    
    dispatch_async(self.animationQueue, ^{
        
        dispatch_group_t animationGroup = dispatch_group_create();
        
        for(NSDIJStruct *tempStruct in itemsToDelete){
            
            if(self.gameField[tempStruct.i][tempStruct.j]!=[NSNull null]){
                
                dispatch_group_enter(animationGroup);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if( ! [self shouldBeApplyRecivedNotification:notification]){
                        
                        dispatch_group_leave(animationGroup);
                    }
                    else{
                        
                        NSUInteger i = tempStruct.i;
                        NSUInteger j = tempStruct.j;
                        
                        [((NSDGameItemView *)self.gameField[i][j]) animateDestroyWithDuration:NSDDeleteAnimationDuration completion:^{
                            
                            [self.gameField[i][j] removeFromSuperview];
                            self.gameField[i][j] = [NSNull null];
                            
                            dispatch_group_leave(animationGroup);
                        }];
                    }
                });
            }
        }
        
        dispatch_group_wait(animationGroup, DISPATCH_TIME_FOREVER);
        
        if(!self.isReplay){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self notifyAboutGameFieldDidEndDeletingWithScoreCount:(NSDItemCost * itemsToDelete.count)];
            });
        }
    });
}

#pragma mark - Notification + ReplayExtention

- (void)processDidDetectEndPlayingReplay{
    
    dispatch_async(self.animationQueue, ^{
        
        dispatch_group_t animationGroup = dispatch_group_create();
        dispatch_group_enter(animationGroup);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!_isReplay || (_isReplay && ![_replayUUID isEqual: [[NSDReplayPlayer sharedInstance] UUID]])) {
                
            }else{
                [self notifyAboutGameFieldDidEndPlayingReplay];
            }
            dispatch_group_leave(animationGroup);
        });
        
        dispatch_group_wait(animationGroup, DISPATCH_TIME_FOREVER);
    });
}


@end
