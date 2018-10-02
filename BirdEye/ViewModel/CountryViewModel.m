//
//  CountryViewModel.m
//  BirdEye
//
//  Created by Xiangwei Wang on 2018/10/01.
//  Copyright © 2018 Xiangwei.Work. All rights reserved.
//

#import "CountryViewModel.h"

@implementation CountryViewModel

-(id) init {
    self = [super init];
    if(self) {
        [self createLoadCountriesCommand];
        [RACObserve(self, active) subscribeNext:^(NSNumber*  _Nullable active) {
            if([active boolValue]) {
                [self.loadCountriesCommand execute:nil];
            }
        }];
        
    }
    return self;
}

-(void) setCountryData:(NSArray *) data {
    NSMutableArray *array = [NSMutableArray array];
    for (NSUInteger i = 65; i <= 90; i++) {
        [array addObject:[NSMutableArray array]];
    }
    for (NSDictionary *country in data) {
        NSString *code = [[country objectForKey:@"code"] uppercaseString];
        char c = [code characterAtIndex:0];
        NSMutableArray *a = [array objectAtIndex:c - 65];
        [a addObject:country];
    }
    for(NSInteger i = [array count] - 1; i >=0; i--) {
        NSMutableArray *a = [array objectAtIndex:i];
        if([a count] == 0) {
            [array removeObjectAtIndex:i];
        }
    }
    
    
    NSMutableArray *indexesArray = [NSMutableArray array];
    for (NSArray *a in array) {
        NSDictionary *country = [a firstObject];
        NSString *code = [[country objectForKey:@"code"] uppercaseString];
        
        [indexesArray addObject:[code substringWithRange:NSMakeRange(0, 1)]];
    }
    
    self.countryArray = array;
    self.countryIndexes = indexesArray;
}

-(NSString *) titleForHeaderInSection:(NSInteger)section {
    NSArray *a = [self.countryArray objectAtIndex:section];
    NSDictionary *country = [a firstObject];
    NSString *code = [[country objectForKey:@"code"] uppercaseString];
    
    return [code substringWithRange:NSMakeRange(0, 1)];
}

-(NSUInteger) sectionForSectionIndexTitle:(NSString *) title {
    NSUInteger i = 0;
    for (NSDictionary *country in self.countryArray) {
        NSString *code = [[country objectForKey:@"code"] uppercaseString];
        
        NSString *t = [code substringWithRange:NSMakeRange(0, 0)];
        if([t isEqualToString:title]) {
            break;
        }
        i++;
    }
    return i;
}
//取得国家一栏
-(void) createLoadCountriesCommand {
    self.loadCountriesCommand = [[RACCommand alloc]  initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable sender) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager sharedManager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        return [manager rac_Get:@"https://www.skypixel.com/api/v2/countries?lang=en-US&platform=web&device=desktop" parameters:nil];
    }];
}

@end
