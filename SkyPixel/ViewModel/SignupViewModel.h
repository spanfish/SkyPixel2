//
//  SignupViewModel.h
//  SkyPixel
//
//  Created by xwang on 9/27/18.
//  Copyright © 2018 Xiang Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>

@interface SignupViewModel : NSObject

@property(nonatomic, strong) NSString *accountType;
@property(nonatomic, strong) NSString *authCode;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *nickName;
@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong) NSString *subscription;

@property(nonatomic, strong) RACCommand *signupCommand;
@end
