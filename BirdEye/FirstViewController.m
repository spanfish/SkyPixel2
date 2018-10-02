//
//  FirstViewController.m
//  BirdEye
//
//  Created by Xiangwei Wang on 2018/09/30.
//  Copyright © 2018 Xiangwei.Work. All rights reserved.
//

#import "FirstViewController.h"
#import "AccountViewModel.h"

@interface FirstViewController ()

@property(nonatomic, strong) AccountViewModel *accountViewModel;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.accountViewModel = [[AccountViewModel alloc] init];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)buttonClicked:(id)sender {
    [self.textField resignFirstResponder];
    
    if(sender == self.authButton) {
        [self.accountViewModel.loadAuthImgCommand execute:nil];
        @weakify(self)
        [[self.accountViewModel.loadAuthImgCommand.executionSignals flatten] subscribeNext:^(RACThreeTuple *x) {
            @strongify(self)
            
            NSURLRequest *request = [x first];
            NSHTTPURLResponse *response = [x second];
            NSAssert([x third] != nil, @"no auth image");
            self.imageView.image = (UIImage *) [x third];
        }];
        
        [self.accountViewModel.loadAuthImgCommand.errors subscribeNext:^(NSError * _Nullable error) {
            NSLog(@"error: %@", error);
        }];
    } else if(sender == self.tokenButton) {
        [self.accountViewModel.loadTokenCommand execute:nil];
        @weakify(self)
        [[self.accountViewModel.loadTokenCommand.executionSignals flatten] subscribeNext:^(RACThreeTuple *x) {
            @strongify(self)
            
            NSURLRequest *request = [x first];
            NSHTTPURLResponse *response = [x second];

        }];
        
        [self.accountViewModel.loadTokenCommand.errors subscribeNext:^(NSError * _Nullable error) {
            NSLog(@"error: %@", error);
        }];
    } else if(sender == self.loginButton) {
        
        self.accountViewModel.authCode = self.textField.text;
        self.accountViewModel.userName = @"wangxw@icloud.com";
        self.accountViewModel.password = @"Zxcvb873";
        NSAssert([self.accountViewModel.userName length] > 0, @"no account name");
        [self.accountViewModel.loginCommand execute:nil];
        @weakify(self)
        [[self.accountViewModel.loginCommand.executionSignals flatten] subscribeNext:^(RACThreeTuple *x) {
            @strongify(self)
            
            NSURLRequest *request = [x first];
            NSHTTPURLResponse *response = [x second];
            
        }];
        
        [self.accountViewModel.loginCommand.errors subscribeNext:^(NSError * _Nullable error) {
            NSLog(@"error: %@", error);
        }];
    } else if(sender == self.updateProfileButton) {
        [self.accountViewModel.updateProfileCommand execute:nil];
        @weakify(self)
        [[self.accountViewModel.updateProfileCommand.executionSignals flatten] subscribeNext:^(RACThreeTuple *x) {
            @strongify(self)
            
            NSURLRequest *request = [x first];
            NSHTTPURLResponse *response = [x second];
            
        }];
        
        [self.accountViewModel.updateProfileCommand.errors subscribeNext:^(NSError * _Nullable error) {
            NSLog(@"error: %@", error);
        }];
    } else if(sender == self.avatarButton) {
            [self.accountViewModel.updateAvatarCommand execute:nil];
            @weakify(self)
            [[self.accountViewModel.updateAvatarCommand.executionSignals flatten] subscribeNext:^(RACThreeTuple *x) {
                @strongify(self)
                
                NSURLRequest *request = [x first];
                NSHTTPURLResponse *response = [x second];
                
            }];
            
            [self.accountViewModel.updateAvatarCommand.errors subscribeNext:^(NSError * _Nullable error) {
                NSLog(@"error: %@", error);
            }];
    } else if(sender == self.cookieButton) {
        NSArray *cookieArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie *cookie in cookieArray) {
            NSLog(@"name=%@, value=%@", cookie.name, cookie.value);
        }
        
    }
    
    
}
@end
