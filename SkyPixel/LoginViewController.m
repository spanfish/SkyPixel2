//
//  SecondViewController.m
//  SkyPixel
//
//  Created by xwang on 9/27/18.
//  Copyright © 2018 Xiang Studio. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewModel.h"
#import "AuthViewModel.h"

@interface LoginViewController ()
{
    LoginViewModel *loginViewModel;
    AuthViewModel *authViewModel;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //form
    RACSignal *formValidSignal =
    
    [RACSignal combineLatest:@[ self.accountTextField.rac_textSignal,
                                self.passwordTextField.rac_textSignal,
                                self.authCodeTextField.rac_textSignal]
                      reduce:^(NSString *username,
                               NSString *password,
                               NSString *authCode) {
                          NSLog( @"%@,%@,%@",
                                username,
                                password,
                                authCode);
                          
                          return @([username length] > 0 && [password length] > 0 && [authCode length] >= 4);
                      }];
    //RAC(self.loginButton, enabled) = formValidSignal;
    loginViewModel = [[LoginViewModel alloc] initWithEnabled:formValidSignal];
    authViewModel = [[AuthViewModel alloc] init];
    
    //Auth image load signal
    RAC(self.authImageView, image) = [RACObserve(authViewModel, authImage) deliverOnMainThread];
    
    //Login command signal
    [loginViewModel.loginCommand.executionSignals subscribeNext:^(RACSignal *loginSignal) {
        // Log a message whenever we log in successfully.
        [loginSignal subscribeNext:^(RACTwoTuple *  _Nullable tuple) {
            NSLog(@"next");
        }];
    }];
    [loginViewModel.loginCommand.errors subscribeNext:^(NSError * _Nullable x) {
        NSLog(@"error");
    }];
    
    self.loginButton.rac_command = loginViewModel.loginCommand;
    
    //input text
    RAC(loginViewModel, userName) = self.accountTextField.rac_textSignal;
    RAC(loginViewModel, password) = self.passwordTextField.rac_textSignal;
    RAC(loginViewModel, authCode) = self.authCodeTextField.rac_textSignal;

    //load auth image
    [authViewModel loadAuthImage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
