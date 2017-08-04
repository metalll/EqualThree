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
NSString * const kNSDfName = @"NSDGameSharedSession";


@interface NSDGameSharedManager ()

@property NSDGameSharedInstance * gameEngineInstance;

- (void)subscribeToNotifications;
- (void)unsubscribeFromNotifications;


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

+(instancetype)new{
    
    NSDGameSharedManager * new = [super new];

    if(new){
        [new subscribeToNotifications];
        [new loadFromStorageWithCompletion:nil];
    }
    
    
    return new;
}

-(void)dealloc{
    [self unsubscribeFromNotifications];
}







-(void)saveFromStorage{
    [NSDPlistController savePlistWithName:kNSDfName andStoredObject:self.gameEngineInstance andCompletion:nil];
}

-(void)loadFromStorageWithCompletion:(void(^)(NSDGameSharedInstance *))completion{
    [NSDPlistController loadPlistWithName:kNSDfName andLoadedObjectClass:[NSMutableDictionary class] andCompletion:^(id retValObject) {
        self.gameEngineInstance = [NSDGameSharedInstance initWithDic:retValObject];
        if(completion)
        completion(self.gameEngineInstance);
    }];
}



#pragma mark - Notifications

-(void)subscribeToNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proccessDidEndOfTransitionsNotification:) name:NSDEndOfTransitions object: nil];
    
}


-(void)unsubscribeFromNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)proccessDidEndOfTransitionsNotification:(NSNotification *)notification{
    self.gameEngineInstance.field = notification.userInfo[kNSDGameItems];
    self.gameEngineInstance.moves = [notification.userInfo[kNSDMoviesCount] unsignedIntegerValue];
    self.gameEngineInstance.score = [notification.userInfo[kNSDUserScore] unsignedIntegerValue];
    self.gameEngineInstance.sharedItemTypesCount = [notification.userInfo[kNSDGameItemsTypeCount] unsignedIntegerValue];
    
    [self saveFromStorage];
}




@end
