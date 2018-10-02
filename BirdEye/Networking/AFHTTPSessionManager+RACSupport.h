//
//  AFHTTPSessionManager+RACSupport.h
//  BirdEye
//
//  Created by Xiangwei Wang on 2018/09/30.
//  Copyright © 2018 Xiangwei.Work. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import <ReactiveObjC.h>

@interface AFHTTPSessionManager (RACSupport)

+(AFHTTPSessionManager *) sharedManager;

-(RACSignal *_Nonnull) rac_Put:(NSString * _Nonnull )URLString
                     parameters:(nullable id)parameters;

-(RACSignal *_Nonnull) rac_Post:(NSString * _Nonnull )URLString
                     parameters:(nullable id)parameters;
-(RACSignal *_Nonnull) rac_Get:(NSString * _Nonnull )URLString
                    parameters:(nullable id)parameters;
-(RACSignal *_Nonnull) rac_Upload:(NSString * _Nonnull )URLString
                    parameters:(nullable id)parameters;
@end
