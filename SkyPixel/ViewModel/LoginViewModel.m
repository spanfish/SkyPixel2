//
//  LoginViewModel.m
//  SkyPixel
//
//  Created by xwang on 9/27/18.
//  Copyright © 2018 Xiang Studio. All rights reserved.
//

#import "LoginViewModel.h"
#import <AFNetworking.h>
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
    
    RACSignal *s;
    
}
@end
