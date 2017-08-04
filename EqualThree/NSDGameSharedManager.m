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

@property NSDGameSharedInstance * gameEngineInstance;

- (void)subscribeToNotifications;
- (void)unsubscribeFromNotifications;

-(void)proccessGoToAwaitStateNotification:(NSNotification *)notification;


@end


@implementation NSDGameSharedManager


static NSDGameSharedManager * instance;
+(instancetype)sharedInstance{

    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NSDGameSharedManager new];
    });
    
    
    
    return instance;

}


-(NSDGameSharedInstance *)lastSavedGame{
    return self.gameEngineInstance;
}

-(void)hasSavedGameWithCompletion:(void(^)(BOOL isHasSavedGame))completion{
   [self loadFromStorageWithCompletion:^(NSDGameSharedInstance * retVal) {
       if(completion){
           completion(retVal!=nil);
           self.gameEngineInstance = retVal;
       }
   }];
}

+(instancetype)new{
    
    NSDGameSharedManager * new = [super new];

    if(new){
        [new subscribeToNotifications];
    }
    
    return new;
}

-(void)dealloc{
    [self unsubscribeFromNotifications];
}


-(void)saveFromStorage{
    [NSDPlistController savePlistWithName:kNSDFileName andStoredObject:[self.gameEngineInstance dic] andCompletion:nil];
}

-(void)loadFromStorageWithCompletion:(void(^)(NSDGameSharedInstance *))completion{
    [NSDPlistController loadPlistWithName:kNSDFileName andLoadedObjectClass:[NSMutableDictionary class] andCompletion:^(id retValObject) {
        self.gameEngineInstance = [NSDGameSharedInstance initWithDic:retValObject];
        if(completion)
        completion(self.gameEngineInstance);
    }];
}



#pragma mark - Notifications

-(void)subscribeToNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proccessGoToAwaitStateNotification:) name:NSDDidGoToAwaitState object: nil];
    
}


-(void)unsubscribeFromNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)proccessGoToAwaitStateNotification:(NSNotification *)notification{
    
    if(self.gameEngineInstance==nil){
        self.gameEngineInstance = [NSDGameSharedInstance new];
    }
    
    self.gameEngineInstance.field = notification.userInfo[kNSDGameItems];
    self.gameEngineInstance.moves = [notification.userInfo[kNSDMovesCount] unsignedIntegerValue];
    self.gameEngineInstance.score = [notification.userInfo[kNSDUserScore] unsignedIntegerValue];
    self.gameEngineInstance.sharedItemTypesCount = [notification.userInfo[kNSDGameItemsTypeCount] unsignedIntegerValue];
    
    [self saveFromStorage];
}




@end
