//
//  GameSharedManager.m
//  EqualThree
//
//  Created by NSD on 03.08.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDGameSharedManager.h"
#import "NSDGameEngine.h"
#import "NSDPlistController.h"

NSString * const kNSDFileName = @"NSDGameSharedSession";

@interface NSDGameSharedManager ()

@property NSDGameSharedInstance *gameEngineInstance;

- (void)subscribeToNotifications;
- (void)unsubscribeFromNotifications;
- (void)proccessGoToAwaitStateNotification:(NSNotification *)notification;

@end

@implementation NSDGameSharedManager

#pragma mark - Contsructors

+ (instancetype)new{
    
    NSDGameSharedManager * new = [super new];
    if(new){
        [new subscribeToNotifications];
    }
    return new;
}

#pragma mark - Destructors

- (void)dealloc{
    
    [self unsubscribeFromNotifications];
}

#pragma mark - Singletone

static NSDGameSharedManager * instance;
+ (instancetype)sharedInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NSDGameSharedManager new];
    });
    
    return instance;
    
}

#pragma mark - Public

- (NSDGameSharedInstance *)lastSavedGame{
    return self.gameEngineInstance;
}


- (void)hasSavedGameWithCompletion:(void (^)(BOOL hasSavedGame))completion{
    [self loadFromStorageWithCompletion:^(NSDGameSharedInstance * retVal) {
        if(completion){
            completion(retVal!=nil);
            self.gameEngineInstance = retVal;
        }
    }];
}


#pragma mark - Storage

- (void)saveFromStorage{
    
    [NSDPlistController savePlistWithName:kNSDFileName andStoredObject:[self.gameEngineInstance dic] andCompletion:nil];
}

- (void)loadFromStorageWithCompletion:(void(^)(NSDGameSharedInstance *))completion{
    [NSDPlistController loadPlistWithName:kNSDFileName andCompletion:^(id retValObject) {
        self.gameEngineInstance = [NSDGameSharedInstance initWithDic:retValObject];
        if(completion)
            completion(self.gameEngineInstance);
    }];
}

- (void)deleteGame{
    
    self.gameEngineInstance = nil;
    [NSDPlistController removeFileWithName:kNSDFileName];
}


#pragma mark - Notifications

- (void)subscribeToNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proccessGoToAwaitStateNotification:) name:NSDDidGoToAwaitState object: nil];
}


- (void)unsubscribeFromNotifications{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)proccessGoToAwaitStateNotification:(NSNotification *)notification{
    
    NSDGameSharedInstance *tempSharedInstance = [NSDGameSharedInstance new];
    
    tempSharedInstance.field = notification.userInfo[kNSDGameItems];
    tempSharedInstance.moves = [notification.userInfo[kNSDMovesCount] unsignedIntegerValue];
    tempSharedInstance.score = [notification.userInfo[kNSDUserScore] unsignedIntegerValue];
    tempSharedInstance.sharedItemTypesCount = [notification.userInfo[kNSDGameItemsTypeCount] unsignedIntegerValue];
    
    if(![[self.gameEngineInstance dic] isEqual:[tempSharedInstance dic]]){
        self.gameEngineInstance = tempSharedInstance;
        [self saveFromStorage];
    }
}

@end
