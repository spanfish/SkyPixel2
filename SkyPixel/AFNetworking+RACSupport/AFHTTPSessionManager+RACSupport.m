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
    
    [self.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
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

-(RACSignal *_Nonnull) rac_Get:(NSString * _Nonnull )URLString
                     parameters:(nullable id)parameters {
    RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:1];
    [subject setName:@"rac_Get"];
    [self.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    [self GET:URLString
   parameters:parameters
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          //[task htt]
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
