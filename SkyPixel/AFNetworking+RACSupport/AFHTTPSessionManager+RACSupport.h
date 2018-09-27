//
//  AFHTTPSessionManager+RACSupport.h
//  SkyPixel
//
//  Created by xwang on 9/27/18.
//  Copyright © 2018 Xiang Studio. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import <ReactiveObjC.h>
@interface AFHTTPSessionManager (RACSupport)

-(RACSignal *_Nonnull) rac_Post:(NSString * _Nonnull )URLString
             parameters:(nullable id)parameters;
@end
