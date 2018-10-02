//
//  AFHTTPSessionManager+RACSupport.m
//  BirdEye
//
//  Created by Xiangwei Wang on 2018/09/30.
//  Copyright © 2018 Xiangwei.Work. All rights reserved.
//

#import "AFHTTPSessionManager+RACSupport.h"

static NSString *UserAgent = @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36";

@implementation AFHTTPSessionManager (RACSupport)

+(AFHTTPSessionManager *) sharedManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //TODO:
    return manager;
}

-(RACSignal *_Nonnull) rac_Put:(NSString * _Nonnull )URLString
                    parameters:(nullable id)parameters {
    RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:1];
    [subject setName:@"AFHTTPSessionManager#rac_Put"];
    
    [self.requestSerializer setValue:UserAgent forHTTPHeaderField:@"User-Agent"];

    [self PUT:URLString
   parameters:parameters
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
          NSURLRequest *request = task.currentRequest;
          [subject sendNext: RACTuplePack(request, response, responseObject)];
          [subject sendCompleted];
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#if DEBUG
          NSURLRequest *request = task.currentRequest;
          NSLog(@"allHTTPHeaderFields:%@", [request allHTTPHeaderFields]);
          NSString *body = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
          NSLog(@"body:%@", body);
#endif
          NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
          NSMutableDictionary *userInfo = [error.userInfo mutableCopy] ?: [NSMutableDictionary dictionary];
          [userInfo setObject:response forKey:@"NSHTTPURLResponse"];
          [subject sendError:[NSError errorWithDomain:error.domain code:error.code userInfo:userInfo]];
      }];
    
    return subject;
}

-(RACSignal *_Nonnull) rac_Post:(NSString * _Nonnull )URLString
                     parameters:(nullable id)parameters {
    RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:1];
    [subject setName:@"AFHTTPSessionManager#rac_Post"];
    
    [self.requestSerializer setValue:UserAgent forHTTPHeaderField:@"User-Agent"];
    
    [self POST:URLString
    parameters:parameters progress:nil
       success:^(NSURLSessionTask * _Nonnull task, id  _Nullable responseObject) {
           NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
           NSURLRequest *request = task.currentRequest;
           [subject sendNext: RACTuplePack(request, response, responseObject)];
           [subject sendCompleted];
       } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
           NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
           NSMutableDictionary *userInfo = [error.userInfo mutableCopy] ?: [NSMutableDictionary dictionary];
           [userInfo setObject:response forKey:@"NSHTTPURLResponse"];
           [subject sendError:[NSError errorWithDomain:error.domain code:error.code userInfo:userInfo]];
       }];
    
    return subject;
}

-(RACSignal *_Nonnull) rac_Upload:(NSString * _Nonnull )URLString
                       parameters:(nullable id)parameters {
    RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:1];
    [subject setName:@"AFHTTPSessionManager#rac_Upload"];
    
    [self.requestSerializer setValue:UserAgent forHTTPHeaderField:@"User-Agent"];
    
     [self POST:URLString
     parameters:parameters
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://cdn-usa.skypixel.com/uploads/usa_files/account/avatar_image/deacc564-f628-40f6-a102-7a7bc0f4eb29.png@!550"]];
    
    [formData appendPartWithHeaders:@{@"Content-Disposition" : @"form-data; name=\"file\"; filename=\"a.png\"",
                                      @"Content-Type" : @"image/png"
                                      } body:imageData];
} progress:^(NSProgress * _Nonnull uploadProgress) {
    
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
    NSURLRequest *request = task.currentRequest;
    [subject sendNext: RACTuplePack(request, response, responseObject)];
    [subject sendCompleted];
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
    NSMutableDictionary *userInfo = [error.userInfo mutableCopy] ?: [NSMutableDictionary dictionary];
    [userInfo setObject:response forKey:@"NSHTTPURLResponse"];
    [subject sendError:[NSError errorWithDomain:error.domain code:error.code userInfo:userInfo]];
}];
    
    return subject;
}

-(RACSignal *_Nonnull) rac_Get:(NSString * _Nonnull )URLString
                    parameters:(nullable id)parameters {
    RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:1];
    [subject setName:@"AFHTTPSessionManager#rac_Get"];
    [self.requestSerializer setValue:UserAgent forHTTPHeaderField:@"User-Agent"];
    [self GET:URLString
   parameters:parameters
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
          NSURLRequest *request = task.currentRequest;
          [subject sendNext: RACTuplePack(request, response, responseObject)];
          [subject sendCompleted];
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
          NSMutableDictionary *userInfo = [error.userInfo mutableCopy] ?: [NSMutableDictionary dictionary];
          [userInfo setObject:response forKey:@"NSHTTPURLResponse"];
          [subject sendError:[NSError errorWithDomain:error.domain code:error.code userInfo:userInfo]];
      }];
    
    return subject;
}
@end
