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




-(void)addRecordWithRecord:(NSDScoreRecord *)record andCompletion:(void (^)(void))completion{

}


-(void) loadManager{
    
    //TBD
    
    
    records = [[NSMutableArray alloc] init];
    
    [records addObject:[[NSDScoreRecord alloc]initWithName:@"Vasya" andScore:133242342]];
    
    [records addObject:[[NSDScoreRecord alloc]initWithName:@"Petya" andScore:543242342]];
    
    [records addObject:[[NSDScoreRecord alloc]initWithName:@"Dasha" andScore:223233342]];
    
    [records addObject:[[NSDScoreRecord alloc]initWithName:@"Masha" andScore:243242]];
    
    
}


static NSDHighscoresManager * manager;
+(instancetype) sharedManager{
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NSDHighscoresManager alloc] init];
        [manager loadManager];
    });
    return manager;
}



-(void)allRecordsWithCompletion:(void (^)(NSArray *))completion{
    
    if(completion!=nil){
    completion(records);
    }

}

@end
