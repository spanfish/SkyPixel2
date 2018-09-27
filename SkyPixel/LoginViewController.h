//
//  SecondViewController.h
//  SkyPixel
//
//  Created by xwang on 9/27/18.
//  Copyright © 2018 Xiang Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property(nonatomic, weak) IBOutlet UIImageView *authImageView;
@property(nonatomic, weak) IBOutlet UITextField *accountTextField;
@property(nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property(nonatomic, weak) IBOutlet UITextField *authCodeTextField;
@property(nonatomic, weak) IBOutlet UIButton *loginButton;
@end

