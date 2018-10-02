//
//  LoginViewModel.m
//  BirdEye
//
//  Created by Xiangwei Wang on 2018/09/30.
//  Copyright © 2018 Xiangwei.Work. All rights reserved.
//

#import "AccountViewModel.h"

@implementation AccountViewModel
-(id) init {
    self = [super init];
    if(self) {
        [self createAuthImgCommand];
        [self createTokenCommand];
        [self createLoginCommand];
        [self createUpdateAvatarCommand];
        [self createUpdateProfileCommand];
    }
    return self;
}

//取得验证码图片
//服务器会发生set cookie，并通过cookie返回Session ID，这个Session ID在以后的调用中必须用到
-(void) createAuthImgCommand {
    self.loadAuthImgCommand = [[RACCommand alloc]  initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable sender) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager sharedManager];
        manager.responseSerializer = [AFImageResponseSerializer serializer];
        manager.requestSerializer.HTTPShouldHandleCookies = YES;
        
        NSString *URLString = [NSString stringWithFormat:@"https://www.skypixel.com/api/v2/auth-image?%@", [AccountViewModel GetUUID]];
        return [manager rac_Get:URLString parameters:nil];
    }];
}

//取得Token
//服务器会发生set cookie，并通过cookie返回csrf_token_v2，这个csrf_token_v2在以后的调用中必须设定到HTTP HEAD:X-CSRF-Token
//Response为204：无内容
-(void) createTokenCommand {
    self.loadTokenCommand = [[RACCommand alloc]  initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable sender) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager sharedManager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.HTTPShouldHandleCookies = YES;
        
        return [manager rac_Get:@"https://www.skypixel.com/api/v2/csrf-token?lang=en-US&platform=web&device=desktop" parameters:nil];
    }];
}

//用户login,服务器会发auth_token_code和logined_user的cookie
//Response为204：无内容
-(void) createLoginCommand {
    @weakify(self)
    self.loginCommand = [[RACCommand alloc]  initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable sender) {
        @strongify(self)
        AFHTTPSessionManager *manager = [AFHTTPSessionManager sharedManager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.requestSerializer.HTTPShouldHandleCookies = YES;
        
        [self addCSRFToken:manager];

        NSDictionary *parameters = @{@"auth_code": self.authCode, @"password" : self.password, @"remembered" : @"false", @"user_name" : self.userName};
        return [manager rac_Post:@"https://www.skypixel.com/api/v2/account/login?lang=en-US&platform=web&device=desktop" parameters:parameters];
    }];
}
//更新头像
//Response为204：无内容
-(void) createUpdateAvatarCommand {
    self.updateAvatarCommand = [[RACCommand alloc]  initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable sender) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager sharedManager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer.HTTPShouldHandleCookies = NO;
        [self addCSRFToken:manager];
        [self addCookie:manager];
        
        return [manager rac_Upload: @"https://www.skypixel.com/api/v2/user/avatar?lang=en-US&platform=web&device=desktop" parameters:nil];
    }];
}

//更新我的信息
-(void) createUpdateProfileCommand {
    RACSignal *nameValidSignal = [RACObserve(self, name) map:^id _Nullable(NSString * _Nullable name) {
        if(name.length > 0) {
            return @(TRUE);
        }
        return @(FALSE);
    }];
    self.updateProfileCommand = [[RACCommand alloc]  initWithEnabled:nameValidSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable sender) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager sharedManager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.requestSerializer.HTTPShouldHandleCookies = YES;
        
        [self addCSRFToken:manager];
        [self addCookie:manager];
        
        NSDictionary *parameters = @{@"country_code": self.countryCode == nil ? [NSNull null] : self.countryCode,
                                     @"description" : self.des == nil ? [NSNull null]  : self.des,
                                     @"facebook" : self.facebook == nil ? [NSNull null]  : self.facebook,
                                     @"google_plus" : self.googlePlus == nil ? [NSNull null]  : self.googlePlus,
                                     @"instagram" : self.instagram == nil ? [NSNull null]  : self.instagram,
                                     @"twitter" : self.twitter == nil ? [NSNull null]  : self.twitter,
                                     @"website" : self.website == nil ? [NSNull null]  : self.website,
                                     @"gender" : self.gender == nil ? [NSNull null]  : self.gender,
                                     @"name" : self.name == nil ? [NSNull null]  : self.name
                                     };
        return [manager rac_Put: @"https://www.skypixel.com/api/v2/user?lang=en-US&platform=web&device=desktop" parameters:parameters];
    }];
}
//在http header里加入X-CSRF-Token
-(void) addCSRFToken:(AFHTTPSessionManager *) manager {
    NSArray *cookieArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookieArray) {
        //查找csrf_token_v2
        if([cookie.name compare:@"csrf_token_v2" options:NSCaseInsensitiveSearch] == kCFCompareEqualTo) {
            [manager.requestSerializer setValue:cookie.value forHTTPHeaderField:@"X-CSRF-Token"];
            break;
        }
    }
}

-(void) addCookie:(AFHTTPSessionManager *) manager {
    NSMutableString *cookieString = [NSMutableString string];
    NSArray *cookieArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookieArray) {
        [cookieString appendFormat: @"%@=%@; ", cookie.name, cookie.value];
    }
    [manager.requestSerializer setValue:cookieString forHTTPHeaderField:@"Cookie"];
}

+ (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}
@end
