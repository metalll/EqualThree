//
//  NSDHighscoresManager.h
//  EqualThree
//
//  Created by NSD on 10.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDScoreRecord.h"

extern NSString * const NSDHighScoreFileName;
extern NSString * const kNSDRecords ;
extern NSString * const kNSDSorted ;


@interface NSDHighscoresManager : NSObject

+(instancetype) sharedManager;

-(void) addRecordWithRecord:(NSDScoreRecord *) record;
-(void) sortedElementsWithCompletion:(void(^)(NSMutableArray * ))completion;

@end
