//
//  NSDHighscoresManager.h
//  EqualThree
//
//  Created by NSD on 10.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDScoreRecord.h"

@interface NSDHighscoresManager : NSObject





+(instancetype) sharedManager;



-(void) addRecordWithRecord:(NSDScoreRecord *) record andCompletion: (void (^) (void))completion;
-(void) allRecordsWithCompletion:(void (^)(NSArray *))completion;





@end
