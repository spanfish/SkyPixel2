//
//  LoginViewModel.h
//  BirdEye
//
//  Created by Xiangwei Wang on 2018/09/30.
//  Copyright © 2018 Xiangwei.Work. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewModel.h"

@interface AccountViewModel : ViewModel

@property(nonatomic, strong) RACCommand *loadAuthImgCommand;
@property(nonatomic, strong) RACCommand *loadTokenCommand;
@property(nonatomic, strong) RACCommand *loginCommand;
@property(nonatomic, strong) RACCommand *updateAvatarCommand;
@property(nonatomic, strong) RACCommand *updateProfileCommand;
//用户输入
@property(nonatomic, strong) NSString *authCode;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong) NSString *remembered;

//用户信息更新输入
@property(nonatomic, strong) NSString *countryCode;
@property(nonatomic, strong) NSString *countryName;
@property(nonatomic, strong) NSString *des;
@property(nonatomic, strong) NSString *gender;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *facebook;
@property(nonatomic, strong) NSString *googlePlus;
@property(nonatomic, strong) NSString *instagram;
@property(nonatomic, strong) NSString *twitter;
@property(nonatomic, strong) NSString *website;

@end
