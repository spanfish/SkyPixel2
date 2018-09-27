//
//  FirstViewController.m
//  SkyPixel
//
//  Created by xwang on 9/27/18.
//  Copyright © 2018 Xiang Studio. All rights reserved.
//

#import "FirstViewController.h"
#import <ReactiveObjC.h>
#import "AuthViewModel.h"
#import "SignupViewModel.h"


@interface FirstViewController ()
{
    AuthViewModel *m ;
    SignupViewModel *viewModel;
}
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    m = [[AuthViewModel alloc] init];
//
//    RAC(self.imageView, image) = [RACObserve(m, authImage) deliverOnMainThread];
//    [m loadAuthImage];

    viewModel = [[SignupViewModel alloc] init];
    [viewModel.signupCommand.executionSignals subscribeNext:^(RACSignal *signupSignal) {
        // Log a message whenever we log in successfully.
        [signupSignal subscribeNext:^(RACTwoTuple *  _Nullable tuple) {
            NSLog(@"next");
        }];
    }];
    [viewModel.signupCommand.errors subscribeNext:^(NSError * _Nullable x) {
        NSLog(@"error");
    }];
    [viewModel.signupCommand execute:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
