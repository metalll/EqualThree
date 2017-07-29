//
//  NSDHighscoresManager.m
//  EqualThree
//
//  Created by NSD on 10.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDHighscoresManager.h"
#import "NSDScoreRecord.h"


@interface NSDHighscoresManager (){
    NSMutableArray * records;
}
@end

@implementation NSDHighscoresManager


#pragma mark - Lazy init

-(void) loadManager{
    self->records = [NSMutableArray new];
    
    
    [self->records addObject:[[NSDScoreRecord alloc] initWithName:@"user" score:43224]];
    [self->records addObject:[[NSDScoreRecord alloc] initWithName:@"user" score:43224]];
    [self->records addObject:[[NSDScoreRecord alloc] initWithName:@"user" score:43224]];
    [self->records addObject:[[NSDScoreRecord alloc] initWithName:@"user" score:43224]];
    [self->records addObject:[[NSDScoreRecord alloc] initWithName:@"user" score:43224]];
    [self->records addObject:[[NSDScoreRecord alloc] initWithName:@"user" score:43224]];
    
    
}


#pragma mark - Sigletone accessor

static NSDHighscoresManager * manager;
+(instancetype) sharedManager{
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NSDHighscoresManager alloc] init];
        [manager loadManager];
    });
    return manager;
}



#pragma mark - Records accessor

-(void)addRecordWithRecord:(NSDScoreRecord *)record andCompletion:(void (^)(void))completion{
    //TBD
}


-(void)allRecordsWithCompletion:(void (^)(NSArray *))completion{
    
    if(completion!=nil){
    completion(records);
    }

}

@end
