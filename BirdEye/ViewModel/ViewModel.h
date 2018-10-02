//
//  ViewModel.h
//  BirdEye
//
//  Created by Xiangwei Wang on 2018/09/30.
//  Copyright © 2018 Xiangwei.Work. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>
#import <AFNetworking.h>
#import "AFHTTPSessionManager+RACSupport.h"

@interface ViewModel : NSObject
@property(nonatomic, assign) BOOL active;
@end
