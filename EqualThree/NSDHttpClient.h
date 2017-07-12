//
//  NSDHttpClient.h
//  EqualThree
//
//  Created by NSD on 10.07.17.
//  Copyright © 2017 NSD NULL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDHttpClient : NSObject

@property NSString * baseURL;
@property NSURLSession * urlSession;

-(NSString *)processResponceWithResponce:(NSURLResponse *)responce andError:(NSError *)error;
-(void)downloadResourceWithURLString:(NSString *)url andCompletion:(void(^)(NSString * localPath,NSString * errorString)) completion;
-(void)performRequestWithURLPath:(NSString *)urlPath
                       andMethod:(NSString *)method
                       andParams:(NSDictionary *)params
           andAcceptJSONResponse:(BOOL) acceptJSONResponse
               andSendBodyAsJSON:(BOOL)sendBodyAsJSON
                   andCompletion:(void(^)(NSData * data,NSString * errorString))completion;

-(void) performRequestWithURLString:(NSString *)url
                          andMethod:(NSString *)method
                          andParams:(NSDictionary *)params
              andAcceptJSONResponse:(BOOL) acceptJSONResponse
                  andSendBodyAsJSON:(BOOL)sendBodyAsJSON
                      andCompletion:(void(^)(NSData * data,NSString * errorString))completion;


@end
