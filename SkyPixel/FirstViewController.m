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

@interface FirstViewController ()
{
    AuthViewModel *m ;
}
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    m = [[AuthViewModel alloc] init];
    
    RAC(self.imageView, image) = [RACObserve(m, authImage) deliverOnMainThread];
    [m loadAuthImage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
