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
NSString * const kNSDSorted = @"kNSDSorted";

@interface NSDHighscoresManager (){
    NSMutableArray *_records;
}

@property BOOL isSorted;
@property BOOL isLoaded;

- (void)allRecordsWithCompletion:(void (^)(NSMutableArray *))completion;
- (void)loadFromFileWithCompletion:(void (^)(NSMutableArray *resultRecords))completion;
- (void)sortRecords;
- (void)saveChangesToFile;

@end

@implementation NSDHighscoresManager

#pragma mark - Constructors

- (instancetype)init{
    
    self = [super init];
    
    if(self){
        
        _records = nil;
        self.isSorted = NO;
    }
    return self;
}


#pragma mark - Sigletone

static NSDHighscoresManager *manager;
+ (instancetype) sharedManager{
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NSDHighscoresManager alloc] init];
        
    });
    return manager;
}

#pragma mark - Public

- (void)addRecordWithRecord:(NSDScoreRecord *)record{
    
    self.isSorted = NO;
    
    NSBlockOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        if(_records == nil){
            _records = [NSMutableArray new];
        }
        
        if([_records containsObject:record]){
            
            [_records removeObject:record];
        }
        
        [_records addObject:record];
        [self saveChangesToFile];
        
    }];
    
    if(_records==nil && !self.isLoaded){
        
        [self allRecordsWithCompletion:^(NSMutableArray *result) {
            
            _records = result;
            [completionOperation start];
        }];
        
    }else{
        
        [completionOperation start];
    }
}

- (void)sortedElementsWithCompletion:(void(^)(NSMutableArray *))completion{
    
    NSBlockOperation * completionOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        if(!self.isSorted){
            
            [self sortRecords];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            completion(_records);
        });
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        if(_records == nil && !self.isLoaded){
            
            [self loadFromFileWithCompletion:^(NSMutableArray *resultRecords) {
                
                [completionOperation start];
            }];
            
        }else{
            
            [completionOperation start];
        }
    });
}

#pragma mark - Private

- (void)allRecordsWithCompletion:(void (^)(NSMutableArray *))completion{
    
    if(_records != nil||self.isLoaded){
        if(completion)
            completion(_records);
        return;
    }
    
    [self loadFromFileWithCompletion:^(NSMutableArray *resultRecords) {
        
        _records = resultRecords;
        
        if(completion)
            completion(_records);
    }];
}

- (void)sortRecords{
    
    _records =  [[NSMutableArray alloc] initWithArray: [[_records copy] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        NSDScoreRecord *fElem = (NSDScoreRecord *) obj1;
        NSDScoreRecord *sElem =(NSDScoreRecord *) obj2;
        
        if(fElem.userScore > sElem.userScore){
            return (NSComparisonResult)NSOrderedAscending;
        }else
            if(fElem.userScore < sElem.userScore){
                return (NSComparisonResult)NSOrderedDescending;
            }else {
                return (NSComparisonResult)NSOrderedDescending;
            }
    }]];
    
    self.isSorted = YES;
}

#pragma mark - Storage

- (void)loadFromFileWithCompletion:(void (^)(NSMutableArray *resultRecords))completion{
    
    [NSDPlistController loadPlistWithName:NSDHighScoreFileName andCompletion:^(id result) {
        
        self.isLoaded = YES;
        
        if(result != nil){
            
            _isSorted = [result[kNSDSorted] isEqual:@"YES"] ? YES : NO;
            _records = result[kNSDRecords];
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

- (void)saveChangesToFile{
    
    NSDictionary *savedDictionary = @{ kNSDRecords : _records,
                                       kNSDSorted  : self.isSorted? @"YES" : @"NO" };
    
    [NSDPlistController savePlistWithName:NSDHighScoreFileName andStoredObject:savedDictionary andCompletion:nil];
}

@end
