//
//  AuthViewModel.h
//  SkyPixel
//
//  Created by xwang on 9/27/18.
//  Copyright © 2018 Xiang Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AuthViewModel : NSObject

@property(nonatomic, strong) UIImage *authImage;
-(void) loadAuthImage;
//+ (NSString *)GetUUID;
@end
