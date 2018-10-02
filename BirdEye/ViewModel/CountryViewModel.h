//
//  CountryViewModel.h
//  BirdEye
//
//  Created by Xiangwei Wang on 2018/10/01.
//  Copyright © 2018 Xiangwei.Work. All rights reserved.
//

#import "ViewModel.h"

@interface CountryViewModel : ViewModel

@property(nonatomic, strong) RACCommand *loadCountriesCommand;
@property(nonatomic, strong) NSArray *countryArray;
@property(nonatomic, strong) NSArray *countryIndexes;

-(NSUInteger) sectionForSectionIndexTitle:(NSString *) title;
-(NSString *) titleForHeaderInSection:(NSInteger)section;
-(void) setCountryData:(NSArray *) data;
@end
