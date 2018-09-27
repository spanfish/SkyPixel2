//
//  LoginViewModel.m
//  SkyPixel
//
//  Created by xwang on 9/27/18.
//  Copyright © 2018 Xiang Studio. All rights reserved.
//

#import "LoginViewModel.h"
#import "AFHTTPSessionManager+RACSupport.h"
#import <ReactiveObjC.h>
@implementation LoginViewModel

-(void) login {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSDictionary *parameters = @{@"auth_code": @"", @"password" : @"", @"remembered" : @"false", @"user_name" : @""};

    [manager POST:@"your_URL" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Complete");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Fail");
    }];
}

-(id) initWithEnabled:(RACSignal *) enabledSignal {
    self = [super init];
    if(self) {
        self.loginCommand = [[RACCommand alloc]  initWithEnabled:enabledSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable sender) {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.requestSerializer.HTTPShouldHandleCookies = YES;
            
            NSDictionary *parameters = @{@"auth_code": self.authCode, @"password" : self.password, @"remembered" : @"false", @"user_name" : self.userName};
            
            //
            return [[manager rac_Get:@"https://www.skypixel.com/api/v2/csrf-token?lang=en-US&platform=web&device=desktop" parameters:nil] concat:[manager rac_Post:@"https://www.skypixel.com/api/v2/account/login?lang=en-US&platform=web&device=desktop" parameters:parameters]];
//            return [manager rac_Post:@"https://www.skypixel.com/api/v2/account/login?lang=en-US&platform=web&device=desktop" parameters:parameters];
        }];
        self.loginCommand.allowsConcurrentExecution = NO;
    }
    return self;
}

//-(id) init {
//    self = [super init];
//    if(self) {
//        self.loginCommand = [[RACCommand alloc]  initWithSignalBlock:^RACSignal * _Nonnull(LoginViewModel *  _Nullable loginViewModel) {
//            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//            manager.responseSerializer = [AFJSONResponseSerializer serializer];
//            //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
//            manager.requestSerializer = [AFJSONRequestSerializer serializer];
//            
//            NSDictionary *parameters = @{@"auth_code": loginViewModel.authCode, @"password" : loginViewModel.password, @"remembered" : @"false", @"user_name" : loginViewModel.userName};
//            
//            return [manager rac_Post:@"https://www.skypixel.com/api/v2/account/login?lang=en-US&platform=web&device=desktop" parameters:parameters];
//        }];
//        self.loginCommand.allowsConcurrentExecution = NO;
//    }
//    return self;
//}
@end
