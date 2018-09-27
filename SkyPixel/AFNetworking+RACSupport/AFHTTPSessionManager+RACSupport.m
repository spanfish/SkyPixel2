//
//  AFHTTPSessionManager+RACSupport.m
//  SkyPixel
//
//  Created by xwang on 9/27/18.
//  Copyright © 2018 Xiang Studio. All rights reserved.
//

#import "AFHTTPSessionManager+RACSupport.h"

@implementation AFHTTPSessionManager (RACSupport)

-(RACSignal *_Nonnull) rac_Post:(NSString * _Nonnull )URLString
                     parameters:(nullable id)parameters {
    RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:1];
    [subject setName:@"rac_Post"];
    
    [self POST:URLString
    parameters:parameters progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           [subject sendNext: RACTuplePack(task, responseObject)];
           [subject sendCompleted];
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSMutableDictionary *userInfo = [error.userInfo mutableCopy] ?: [NSMutableDictionary dictionary];
           [userInfo setObject:task forKey:@"NSURLSessionDataTask"];
           [subject sendError:[NSError errorWithDomain:error.domain code:error.code userInfo:userInfo]];
       }];
    
    return subject;
}
@end
