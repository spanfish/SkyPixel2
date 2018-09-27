//
//  SignupViewModel.m
//  SkyPixel
//
//  Created by xwang on 9/27/18.
//  Copyright © 2018 Xiang Studio. All rights reserved.
//

#import "SignupViewModel.h"
#import "AFHTTPSessionManager+RACSupport.h"

@implementation SignupViewModel

-(id) init {
    self = [super init];
    if(self) {
        self.signupCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            
            NSDictionary *parameters = @{@"auth_code": @"", @"password" : @"", @"remembered" : @"false", @"user_name" : @""};
            return [manager rac_Post:@"" parameters:parameters];
        }];
    }
    return self;
}
@end
