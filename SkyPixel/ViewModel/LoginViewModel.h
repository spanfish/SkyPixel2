//
//  LoginViewModel.h
//  SkyPixel
//
//  Created by xwang on 9/27/18.
//  Copyright © 2018 Xiang Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginViewModel : NSObject


@property(nonatomic, strong) NSString *authCode;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong) NSString *remembered;
@end