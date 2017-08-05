//
//  NSDHighscoresManager.m
//  EqualThree
//
//  Created by NSD on 10.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import "NSDHighscoresManager.h"
#import "NSDScoreRecord.h"
#import "NSDPlistController.h"


NSString * const NSDHighScoreFileName = @"NSDHighScore";

NSString * const kNSDRecords = @"kNSDRecords";
NSString * const kNSDIsSorted = @"kNSDIsSorted";



@interface NSDHighscoresManager (){
    NSMutableArray * records;
}

@property BOOL  isSorted;
@property BOOL isLoaded;
@end

@implementation NSDHighscoresManager



-(instancetype)init{
    
    if(self){
        
        self->records = nil;
        self->_isSorted = NO;
        
    }
    return self;
}


#pragma mark - Sigletone accessor

static NSDHighscoresManager * manager;
+(instancetype) sharedManager{
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NSDHighscoresManager alloc] init];
        
    });
    return manager;
}



#pragma mark - Records accessor

-(void)addRecordWithRecord:(NSDScoreRecord *)record{
    
    
    if(self->records==nil){
    
        self->records = [NSMutableArray new];
        
    }
    
    [self->records addObject:record];
    
    [self saveChangesToFile];
    
}


-(void)sortedElementsWithCompletion:(void(^)(NSArray * ))completion{
    
    
    if(self.isSorted){
        
        completion(self->records);
        
    }
    else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            if(self->records==nil){
            
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    if(completion){
                    
                        completion(nil);
                        
                    }
                    
                });
                return;
            }
            
            [self->records sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                
                NSDScoreRecord * fElem = (NSDScoreRecord *) obj1;
                NSDScoreRecord * sElem =(NSDScoreRecord *) obj2;
                
                if(fElem.userScore < sElem.userScore){
                    
                    return (NSComparisonResult)NSOrderedAscending;
                    
                }else
                    
                    if(fElem.userScore > sElem.userScore){
                        
                        return (NSComparisonResult)NSOrderedDescending;
                    
                    }else{
                        
                        return (NSComparisonResult)NSOrderedSame;
                        
                    }
                
                
                
                
            }];
         
            dispatch_async(dispatch_get_main_queue(), ^{
               
                self.isSorted = YES;
                if(completion){
                    completion(self->records);
                }
            });
            
            
            
            
        });
        
        
        
        
    }
    
    
    
}

-(void)allRecordsWithCompletion:(void (^)(NSArray *))completion{
    
    self.isSorted = NO;
    
    if(self->records!=nil||self.isLoaded){
        if(completion)
            completion(self->records);
        return;
    }
    
    [self loadFromFileWithCompletion:^(NSMutableArray *resultRecords) {
        
        self->records = resultRecords;
        
        if(completion)
            completion(self->records);
        
    }];
    
    
}


-(void)loadFromFileWithCompletion:(void(^)(NSMutableArray * resultRecords)) completion{
    [NSDPlistController loadPlistWithName:NSDHighScoreFileName andLoadedObjectClass:[NSMutableDictionary class] andCompletion:^(id result) {
        
        
        self.isLoaded=YES;
        
        if(result!=nil){
            
            self->_isSorted = [result[kNSDIsSorted] isEqual:@"YES"]?YES:NO;
            self->records = result[kNSDRecords];
        }
        
        
        if(completion){
            
            if(result){
                
                completion(result[kNSDRecords]);
                
            }else{
                
                completion(nil);
            }
            
        }
        
    }];
    
    
    
    
    
    
    
}

-(void)saveChangesToFile{
    
    NSDictionary * savedDictionary = @{
                                       
                                       kNSDRecords : self->records,
                                       kNSDIsSorted : self.isSorted?@"YES":@"NO"
                                       };
    
    [NSDPlistController savePlistWithName:NSDHighScoreFileName andStoredObject:savedDictionary andCompletion:nil];
    
    
}


@end
