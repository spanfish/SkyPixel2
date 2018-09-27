//
//  AuthViewModel.m
//  SkyPixel
//
//  Created by xwang on 9/27/18.
//  Copyright © 2018 Xiang Studio. All rights reserved.
//

#import "AuthViewModel.h"
#import <AFNetworking.h>
#import <ReactiveObjC.h>

@implementation AuthViewModel

-(void) loadAuthImage {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    
    NSString *URLString = [NSString stringWithFormat:@"https://www.skypixel.com/api/v2/auth-image?%@", [AuthViewModel GetUUID]];
    
    [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.authImage = (UIImage *) responseObject;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Fail");
        self.authImage = nil;
    }];
}

+ (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}
@end
